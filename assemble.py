import os
import xml.etree.ElementTree as ET
import shutil
import hashlib
import subprocess
import zipfile
import re
import hashlib



def get_version_from_pubspec():
    """
    Extracts the version from pubspec.yaml file.

    :return: The version string or default "1.0.2" if not found.
    """
    try:
        pubspec_path = "pubspec.yaml"
        if not os.path.exists(pubspec_path):
            print(f"Warning: {pubspec_path} not found. Using default version.")
            return "1.0.2"

        with open(pubspec_path, 'r') as file:
            content = file.read()

        # Use regex to find the version line
        match = re.search(r'version:\s*(\d+\.\d+\.\d+)', content)
        if match:
            version = match.group(1)
            print(f"Extracted version from pubspec.yaml: {version}")
            return version
        else:
            print("Warning: Version not found in pubspec.yaml. Using default version.")
            return "1.0.2"
    except Exception as e:
        print(f"Error reading pubspec.yaml: {e}. Using default version.")
        return "1.0.2"


def remove_folders(base_dir):
    """
    Recursively removes folders containing '_debug' or '_profile' in their names
    and all their subdirectories within the specified base directory.

    :param base_dir: The directory to search and remove folders from.
    """
    for root, dirs, files in os.walk(base_dir, topdown=False):
        for dir_name in dirs:
            if '_debug' in dir_name or '_profile' in dir_name:
                folder_path = os.path.join(root, dir_name)
                try:
                    shutil.rmtree(folder_path)
                    print(f"Removed folder: {folder_path}")
                except Exception as e:
                    print(f"Error removing folder {folder_path}: {e}")

def arrange_files(base_dir, namespace, version):
    """
    Recursively organizes files into a Maven Central-compatible directory structure.

    :param base_dir: The root directory to search for .aar, .jar, and .pom files.
    :param namespace: The namespace for the Maven Central repository (e.g., 'com.amwal-pay').
    :param version: The version of the artifacts (e.g., '1.0').
    """
    try:
        # Convert namespace to directory structure
        namespace_dir = namespace.replace('.', os.sep)

        for root, _, files in os.walk(base_dir):
            for file_name in files:
                if file_name.endswith(('.aar', '.jar', '.pom')):
                    # Extract artifact ID from the file name
                    artifact_id = file_name.split('-')[0].replace('_release', '').strip()

                    # Create the target directory
                    target_dir = os.path.join(base_dir, namespace_dir, artifact_id, version)
                    os.makedirs(target_dir, exist_ok=True)

                    # Check if the target file already exists
                    target_file_name = f"{artifact_id}-{version}{os.path.splitext(file_name)[1]}"
                    target_path = os.path.join(target_dir, target_file_name)
                    if os.path.exists(target_path):
                        print(f"Skipping existing file: {target_path}")
                        continue

                    # Move the file
                    src_path = os.path.join(root, file_name)
                    shutil.move(src_path, target_path)

                    print(f"Moved: {src_path} -> {target_path}")

        print("Files arranged successfully!")
    except Exception as e:
        print(f"An error occurred: {e}")



# Define the groupIds to replace
group_ids_to_replace = [
    "dev.fluttercommunity.plus.share",
    "dev.fluttercommunity.plus.packageinfo",
    "io.flutter.plugins.nfc_manager",
    "io.flutter.plugins.firebase.crashlytics",
    "io.flutter.plugins.pathprovider",
    "io.flutter.plugins.sharedpreferences",
    "fman.ge.smart_auth",
    "io.flutter.plugins.webviewflutter",
    "io.flutter.plugins.firebase.core",
    "com.amwal_pay.flutter",
    "com.amwalpay.sdk",
]

new_group_id = "com.amwal-pay"


def process_pom_file(file_path):
    """
    Parses and updates a POM file's groupId and artifactId as needed.
    """
    try:
        # Parse the POM file
        tree = ET.parse(file_path)
        root = tree.getroot()

        namespace = {'maven': 'http://maven.apache.org/POM/4.0.0'}
        ET.register_namespace('', namespace['maven'])

        modified = False

        # Iterate through dependencies
        for dependency in root.findall(".//maven:dependency", namespace):
            group_id = dependency.find("maven:groupId", namespace)
            artifact_id = dependency.find("maven:artifactId", namespace)

            # Skip processing if groupId is "io.flutter"
            if group_id is not None and group_id.text == "io.flutter":
                continue

            # Replace groupId if it matches the target list
            if group_id is not None and group_id.text in group_ids_to_replace:
                group_id.text = new_group_id
                modified = True

            # Remove "_release" suffix from artifactId
            if artifact_id is not None and "_release" in artifact_id.text:
                artifact_id.text = artifact_id.text.replace("_release", "")
                modified = True

        # Write changes back to file if modified
        if modified:
            tree.write(file_path, encoding="utf-8", xml_declaration=True)
            print(f"Updated: {file_path}")
    except Exception as e:
        print(f"Error processing {file_path}: {e}")

# Example usage


def process_directory(directory):
    """
    Recursively processes all .pom files in the specified directory.
    """
    for root, _, files in os.walk(directory):
        for file in files:
            if file.endswith(".pom"):
                file_path = os.path.join(root, file)
                process_pom_file(file_path)



def add_meta_to_pom(file_path, namespace):
    """
    Adds metadata to the specified .pom file and ensures artifactId and groupId comply with conventions.
    :param file_path: The path to the .pom file.
    :param namespace: The valid namespace for <groupId>.
    """
    try:
        tree = ET.parse(file_path)
        root = tree.getroot()

        # Define the namespaces used in the .pom file
        namespaces = {'': 'http://maven.apache.org/POM/4.0.0'}
        ET.register_namespace('', namespaces[''])
        # Ensure <groupId> is set to the namespace
        group_id = root.find('groupId', namespaces)
        if group_id is not None:
            # Set the groupId to the given namespace
            group_id.text = namespace
        else:
            # Add <groupId> if it doesn't exist
            group_id = ET.SubElement(root, 'groupId')
            group_id.text = namespace


        # Ensure <artifactId> does not have the _release suffix
        artifact_id = root.find('artifactId', namespaces)
        if artifact_id is not None and artifact_id.text.endswith('_release'):
            artifact_id.text = artifact_id.text.replace('_release', '')

        # Add project details if not present
        if root.find('name', namespaces) is None:
            ET.SubElement(root, 'name').text = "Amwal SDK"
        if root.find('description', namespaces) is None:
            ET.SubElement(root, 'description').text = "A sample SDK for Amwal Pay."
        if root.find('inceptionYear', namespaces) is None:
            ET.SubElement(root, 'inceptionYear').text = "2024"
        if root.find('url', namespaces) is None:
            ET.SubElement(root, 'url').text = "https://amwal-pay.com"

        # Add <licenses> if not present
        if root.find('licenses', namespaces) is None:
            licenses = ET.Element('licenses')
            license = ET.SubElement(licenses, 'license')
            ET.SubElement(license, 'name').text = "The Apache License, Version 2.0"
            ET.SubElement(license, 'url').text = "http://www.apache.org/licenses/LICENSE-2.0.txt"
            ET.SubElement(license, 'distribution').text = "repo"
            root.append(licenses)

        # Add <developers> if not present
        if root.find('developers', namespaces) is None:
            developers = ET.Element('developers')
            developer = ET.SubElement(developers, 'developer')
            ET.SubElement(developer, 'id').text = "amr.elskaan"
            ET.SubElement(developer, 'name').text = "Amr Said"
            ET.SubElement(developer, 'url').text = "amr.elskaan@amwal-pay.com"
            root.append(developers)

        # Add <scm> if not present
        if root.find('scm', namespaces) is None:
            scm = ET.Element('scm')
            ET.SubElement(scm, 'url').text = "https://github.com/username/mylibrary/"
            ET.SubElement(scm, 'connection').text = "scm:git:git://github.com/username/mylibrary.git"
            ET.SubElement(scm, 'developerConnection').text = "scm:git:ssh://git@github.com/username/mylibrary.git"
            root.append(scm)

        # Write back changes to the file
        tree.write(file_path, encoding='utf-8', xml_declaration=True)
        print(f"Updated: {file_path}")

    except ET.ParseError as e:
        print(f"Error parsing {file_path}: {e}")
    except Exception as e:
        print(f"Error updating {file_path}: {e}")

def find_all_poms(base_dir, namespace):
    """
    Recursively finds all .pom files in the given base directory and updates them.
    :param base_dir: The base directory to search for .pom files.
    :param namespace: The valid namespace for <groupId>.
    """
    for root, dirs, files in os.walk(base_dir):
        for file in files:
            if file.endswith('.pom'):
                file_path = os.path.join(root, file)
                add_meta_to_pom(file_path, namespace)

def generate_checksum(file_path, algorithm):
    """
    Generates a checksum for a given file using the specified algorithm.
    :param file_path: Path to the file.
    :param algorithm: Hash algorithm (e.g., 'md5', 'sha1', 'sha256', 'sha512').
    :return: The checksum value.
    """
    hash_func = getattr(hashlib, algorithm)()
    with open(file_path, "rb") as f:
        while chunk := f.read(8192):
            hash_func.update(chunk)
    return hash_func.hexdigest()

def create_checksum_files(file_path):
    """
    Creates checksum files (.md5, .sha1, .sha256, .sha512) for a given file.
    :param file_path: Path to the file.
    """
    for algo in ["md5", "sha1", "sha256", "sha512"]:
        checksum = generate_checksum(file_path, algo)
        checksum_file = f"{file_path}.{algo}"
        with open(checksum_file, "w") as f:
            f.write(checksum)
        print(f"Generated {algo} checksum: {checksum_file}")



import subprocess
import os

def sign_and_update_checksums(base_dir):
    """
    Recursively signs all .aar, .jar, and .pom files in the given base directory using GPG,
    and updates their checksum files. The GPG key is hardcoded and imported dynamically.
    :param base_dir: The base directory to search for files.
    """
    gpg_passphrase = "amwal@2025"  # Replace with your GPG passphrase

    # Hardcoded GPG private key
    GPG_PRIVATE_KEY = """
-----BEGIN PGP PRIVATE KEY BLOCK-----

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
QtVx1DfjNsCVo+ewDB7WwHwczQSd6g==
=3+sS
-----END PGP PRIVATE KEY BLOCK-----
"""

    try:
        # Import the hardcoded GPG private key
        print("Importing GPG private key...")
        subprocess.run(
            ["gpg", "--batch", "--import"],
            input=GPG_PRIVATE_KEY,  # Pass string directly as input
            text=True,  # Input/output as text
            capture_output=True,
            check=True
        )
        print("GPG key imported successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Error importing GPG key: {e.stderr}")
        return
    except Exception as e:
        print(f"Unexpected error importing GPG key: {e}")
        return

    try:
        # Process files and sign them
        for root, dirs, files in os.walk(base_dir):
            for file in files:
                if file.endswith(('.aar', '.jar', '.pom')):
                    file_path = os.path.join(root, file)
                    try:
                        print(f"Signing file: {file_path}")
                        # Execute GPG signing command with passphrase
                        subprocess.run([
                            "gpg", "--batch", "--yes", "--sign", "--detach-sign", "--armor",
                            "--pinentry-mode", "loopback", "--passphrase", gpg_passphrase, file_path
                        ], capture_output=True, text=True, check=True)
                        print(f"File signed successfully: {file_path}")
                        # Optionally create checksum files (function not provided in the original code)
                        create_checksum_files(file_path)
                    except subprocess.CalledProcessError as e:
                        print(f"Error signing {file_path}: {e.stderr}")
                    except Exception as e:
                        print(f"Unexpected error signing {file_path}: {e}")
    finally:
       cleanup_gpg_keys()

def create_checksum_files(file_path):
    """
    Creates checksum files for the specified file using Python's hashlib.
    :param file_path: The path of the file to generate checksums for.
    """
    try:
        for algo in ["sha256", "sha512"]:
            checksum_file = f"{file_path}.{algo}"
            hash_func = hashlib.new(algo)
            with open(file_path, "rb") as f:
                # Read the file in chunks to avoid memory issues with large files
                while chunk := f.read(8192):
                    hash_func.update(chunk)
            checksum = hash_func.hexdigest()

            # Write the checksum to a file
            with open(checksum_file, "w") as f:
                f.write(f"{checksum}  {file_path}\n")
        print(f"Checksums created for {file_path}.")
    except Exception as e:
        print(f"Unexpected error creating checksum files for {file_path}: {e}")

def cleanup_gpg_keys():
    """
    Cleans up imported GPG keys by deleting them using their full fingerprint.
    """
    try:
        # Get the full fingerprint of secret keys
        key_list_output = subprocess.run(
            ["gpg", "--list-secret-keys", "--with-colons"],
            capture_output=True, text=True, check=True
        )
        fingerprints = [
            line.split(":")[9]
            for line in key_list_output.stdout.splitlines()
            if line.startswith("fpr")
        ]

        # Delete each key using its full fingerprint
        for fingerprint in fingerprints:
            print(f"Deleting imported key: {fingerprint}")
            subprocess.run(
                ["gpg", "--batch", "--yes", "--delete-secret-keys", fingerprint],
                check=True
            )
        print("All imported keys deleted successfully.")
    except subprocess.CalledProcessError as e:
        print(f"Error cleaning up GPG keys: {e.stderr}")
    except Exception as e:
        print(f"Unexpected error cleaning up GPG keys: {e}")



def zip_amwal_pay_only(base_dir, subfolder, output_zip):
    """
    Compresses the com/amwal-pay folder into a zip file while preserving the com/amwal-pay structure,
    but excludes any other subfolders in com.

    :param base_dir: The base directory containing the 'com' folder.
    :param subfolder: The subfolder inside 'com' to include in the zip (e.g., 'amwal-pay').
    :param output_zip: Path for the output zip file.
    """
    try:
        target_folder = os.path.join(base_dir, "com", subfolder)

        if not os.path.exists(target_folder):
            print(f"Folder {target_folder} does not exist!")
            return

        with zipfile.ZipFile(output_zip, 'w', zipfile.ZIP_DEFLATED) as zipf:
            for root, dirs, files in os.walk(target_folder):
                for file in files:
                    file_path = os.path.join(root, file)
                    # Preserve the relative path starting from the base_dir
                    arcname = os.path.relpath(file_path, base_dir)
                    zipf.write(file_path, arcname)

        print(f"Folder successfully zipped into: {output_zip}")
    except Exception as e:
        print(f"Error while zipping folder: {e}")


def update_pom_dependency_version(file_path, group_id_value, artifact_id_value, new_version):
    """
    Updates the version of a specific dependency in a .pom file.

    :param file_path: Path to the .pom file.
    :param group_id_value: The <groupId> value to match.
    :param artifact_id_value: The <artifactId> value to match.
    :param new_version: The new version to set for the dependency.
    """
    try:
        # Parse the POM file
        tree = ET.parse(file_path)
        root = tree.getroot()

        # Define the namespace
        namespace = {'maven': 'http://maven.apache.org/POM/4.0.0'}
        ET.register_namespace('', namespace['maven'])

        updated = False

        # Find all dependencies
        for dependency in root.findall(".//maven:dependency", namespace):
            group_id = dependency.find("maven:groupId", namespace)
            artifact_id = dependency.find("maven:artifactId", namespace)
            version = dependency.find("maven:version", namespace)

            # Check if the groupId and artifactId match
            if (
                    group_id is not None
                    and artifact_id is not None
                    and group_id.text == group_id_value
                    and artifact_id.text == artifact_id_value
            ):
                if version is not None:
                    # Update the version
                    version.text = new_version
                    updated = True
                else:
                    # Add a <version> tag if it doesn't exist
                    version = ET.SubElement(dependency, "version")
                    version.text = new_version
                    updated = True

        # Save changes back to the file if updated
        if updated:
            tree.write(file_path, encoding="utf-8", xml_declaration=True)
            print(f"Updated version in: {file_path}")
        else:
            print(f"No matching dependency found in: {file_path}")

    except ET.ParseError as e:
        print(f"Error parsing {file_path}: {e}")
    except Exception as e:
        print(f"Error updating {file_path}: {e}")


def search_and_update_poms(base_dir, group_id_value, artifact_id_value, new_version):
    """
    Searches for .pom files in a directory and updates the version for a specific dependency.

    :param base_dir: Base directory to search for .pom files.
    :param group_id_value: The <groupId> value to match.
    :param artifact_id_value: The <artifactId> value to match.
    :param new_version: The new version to set for the dependency.
    """
    for root, _, files in os.walk(base_dir):
        for file in files:
            if file.endswith(".pom"):
                file_path = os.path.join(root, file)
                update_pom_dependency_version(file_path, group_id_value, artifact_id_value, new_version)




import os
import xml.etree.ElementTree as ET

def update_pom_dependency_version(pom_file, group_id_value, artifact_id_value, new_version):
    """
    Updates the version of a specific dependency in a `.pom` file.

    Args:
        pom_file (str): The path to the `.pom` file.
        group_id_value (str): The <groupId> value to match.
        artifact_id_value (str): The <artifactId> value to match.
        new_version (str): The new version to set for the dependency.
    """
    try:
        tree = ET.parse(pom_file)
        root = tree.getroot()

        # Define the namespace used in the POM file
        ns = {'maven': 'http://maven.apache.org/POM/4.0.0'}
        ET.register_namespace('', 'http://maven.apache.org/POM/4.0.0')

        # Find all dependencies
        dependencies = root.findall('.//maven:dependency', ns)

        updated = False
        for dependency in dependencies:
            group_id = dependency.find('maven:groupId', ns)
            artifact_id = dependency.find('maven:artifactId', ns)
            version = dependency.find('maven:version', ns)

            if (
                group_id is not None and group_id.text == group_id_value and
                artifact_id is not None and artifact_id.text == artifact_id_value
            ):
                # Update version if found
                if version is not None:
                    version.text = new_version
                    updated = True

        if updated:
            tree.write(pom_file, encoding='utf-8', xml_declaration=True)
            print(f"Updated {pom_file}: {group_id_value}:{artifact_id_value} -> {new_version}")
        else:
            print(f"No matching dependency found in {pom_file}")
    except Exception as e:
        print(f"Error updating {pom_file}: {e}")


def search_and_update_poms(base_dir, group_id_value, artifact_id_value, new_version):
    """
    Recursively searches for `.pom` files in the given directory and updates the version of a specific dependency.

    Args:
        base_dir (str): The base directory to search in.
        group_id_value (str): The <groupId> value to match.
        artifact_id_value (str): The <artifactId> value to match.
        new_version (str): The new version to set for the dependency.
    """
    for root, _, files in os.walk(base_dir):
        for file in files:
            if file.endswith('.pom'):
                pom_file_path = os.path.join(root, file)
                update_pom_dependency_version(pom_file_path, group_id_value, artifact_id_value, new_version)



if __name__ == "__main__":
    # Define paths and configurations
    base_directory = "publish_build"  # Update with the correct directory
    namespace = "com.amwal-pay"  # Namespace for Maven artifacts
    version = get_version_from_pubspec()  # Get version from pubspec.yaml
    output_zip_file = "amwal_sdk.zip"
    amwal_pay_folder = "amwal-pay"

    # Step 1: Remove debug/profile folders
    remove_folders(base_directory)

    # Step 2: Arrange files into Maven Central-compatible structure
    arrange_files(base_directory, namespace, version)

    # Step 3: Process .pom files to ensure they are correctly formatted
    find_all_poms(base_directory, namespace)

    process_directory(base_directory)

    search_and_update_poms(base_directory, namespace, "flutter", version)
    # Step 4: Sign and generate checksums for artifacts
    sign_and_update_checksums(base_directory)

    # Step 5: Zip the relevant folder (com.amwal-pay)
    zip_amwal_pay_only(base_directory, amwal_pay_folder, output_zip_file)


import os
import xml.etree.ElementTree as ET
import shutil
import hashlib
import subprocess
import zipfile
import requests


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

def sign_and_update_checksums(base_dir):
    """
    Recursively signs all .aar, .jar, and .pom files in the given base directory using GPG,
    and updates their checksum files.
    :param base_dir: The base directory to search for files.
    """
    gpg_passphrase = "amwal@2025"  # Replace with your GPG passphrase

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
                    ], check=True)
                    # Create checksum files
                    create_checksum_files(file_path)
                except subprocess.CalledProcessError as e:
                    print(f"Error signing {file_path}: {e}")
                except Exception as e:
                    print(f"Unexpected error signing {file_path}: {e}")


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



def upload_zip(api_url, api_key, file_path):
    """
    Uploads a ZIP file to the specified API endpoint.

    :param api_url: The API endpoint URL.
    :param api_key: The API key (Base64-encoded username:password).
    :param file_path: The path to the ZIP file to upload.
    :return: Response object containing the API's response.
    """
    # Headers for the request
    headers = {
        "accept": "text/plain",
        "Authorization": f"Basic {api_key}",
    }

    # File to upload
    try:
        with open(file_path, "rb") as file:
            files = {"bundle": file}
            # Sending the POST request
            response = requests.post(api_url, headers=headers, files=files)

        # Return the response object for further handling
        return response
    except FileNotFoundError:
        print(f"Error: The file at {file_path} was not found.")
        return None
    except Exception as e:
        print(f"An error occurred: {e}")
        return None

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
    version = "1.0.5"  # Version of the artifacts
    output_zip_file = "amwal_sdk.zip"
    amwal_pay_folder = "amwal-pay"
    API_URL = "https://central.sonatype.com/api/v1/publisher/upload"
    API_KEY = "P9owjrka:KJy8OMMjQb/jK5IZc1YckjrbU9IH7VaU4KAf67uLK5Wh="

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

    # Step 6: Upload the ZIP file
    response = upload_zip(API_URL, API_KEY, output_zip_file)
    if response and response.status_code == 200:
        print(f"Upload successful: {response.json()}")
    else:
        print(f"Upload failed: {response.status_code if response else 'No response'}")

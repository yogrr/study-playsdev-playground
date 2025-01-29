import json
import os
import subprocess
import sys
from http import HTTPStatus

from InquirerPy import inquirer
from pygments import formatters, highlight, lexers

from ..api import (
    create_yc_vm_instance,
    delete_yc_vm_instance,
    get_list_yc_vm_instances,
    get_yc_vm_instance,
    update_yc_vm_instance_user_data,
)


def handle_create_instance_command() -> None:
    name = inquirer.text(message="Enter instance name:").execute() or ""  # type: ignore
    status, _ = create_yc_vm_instance(name)

    if status == HTTPStatus.OK:
        print(f"Successfully created Yandex.Cloud instance with name: {name}")
    else:
        print(
            f"Error occured while creating Yandex.Cloud instance with name {name}",  # noqa: E501
            file=sys.stderr,
        )


def handle_get_instances_info_command() -> None:
    status, info = get_list_yc_vm_instances(os.getenv("FOLDER_ID") or "empty_folder_id")

    if status == HTTPStatus.OK:
        colorful_info = highlight(
            info, lexers.JsonLexer(), formatters.TerminalFormatter()
        )
        print(colorful_info)
    else:
        print(
            "Error occured while getting list of instances Yandex.Cloud",
            file=sys.stderr,
        )


def handle_get_single_instance_info_command() -> None:
    id = inquirer.text(message="Enter instance's ID:").execute() or ""  # type: ignore
    status, info = get_yc_vm_instance(id)

    if status == HTTPStatus.OK:
        colorful_info = highlight(
            info, lexers.JsonLexer(), formatters.TerminalFormatter()
        )
        print(colorful_info)
    else:
        print(
            "Error occured while getting list of instances Yandex.Cloud",
            file=sys.stderr,
        )


def handle_add_instance_ssh_pubkey_command() -> None:
    id = inquirer.text(message="Enter instance's ID:").execute() or ""  # type: ignore
    print()
    print("Be sure to keep previous data from user-data field")
    print()
    user_data = (
        inquirer.text(  # type: ignore
            message=(
                "Enter instance's new user-data field in metadata "
                + "(!IMPORTANT!: like .yml file):"
            )
        ).execute()
        or ""
    )
    # TODO: find a better way to make a new SSH-key

    # _, info = get_yc_vm_instance(id)
    # info = json.loads(info)  # type: ignore
    # ip = info["networkInterfaces"][0]["primaryV4Address"]["oneToOneNat"]["address"]  # type: ignore

    # subprocess.run(
    #     f'ssh yogrr@{ip} "echo {ssh_key} | tee -a .ssh/authorized_keys"',
    #     shell=True,
    #     capture_output=True,
    #     text=True,
    #     check=False,
    # )
    status, _ = update_yc_vm_instance_user_data(id, user_data)

    if status == HTTPStatus.OK:
        print(f"Instance with id:'{id}' now has new ssh-key value in metadata")
    else:
        print(
            f"Error occured while deleting instance with id: {id} Yandex.Cloud",
            file=sys.stderr,
        )


def handle_delete_instances_command() -> None:
    id = inquirer.text(message="Enter instance's ID:").execute() or ""  # type: ignore
    status, _ = delete_yc_vm_instance(id)

    if status == HTTPStatus.OK:
        print(f"Instance with id:'{id}' is deleting now")
    else:
        print(
            "Error occured while getting list of instances Yandex.Cloud",
            file=sys.stderr,
        )

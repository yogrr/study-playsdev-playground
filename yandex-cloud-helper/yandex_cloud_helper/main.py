from dotenv import load_dotenv
from InquirerPy import inquirer

from .menu import (
    AppChoice,
    choices,
    handle_add_instance_ssh_pubkey_command,
    handle_create_instance_command,
    handle_delete_instances_command,
    handle_get_instances_info_command,
    handle_get_single_instance_info_command,
)


def main() -> None:
    load_dotenv()

    print("""

        Welcome!

        This program will help you to work with instances
        in Yandex.Cloud's Compute Cloud

    """)

    while True:
        try:
            choice = inquirer.select(  # type: ignore
                choices=choices,
                cycle=True,
                message="What would you like to do?",
            ).execute()

            if choice == AppChoice.CREATE_INSTANCE:
                handle_create_instance_command()

            elif choice == AppChoice.GET_INSTANCES_INFO:
                handle_get_instances_info_command()

            elif choice == AppChoice.GET_INSTANCE_INFO:
                handle_get_single_instance_info_command()

            elif choice == AppChoice.UPDATE_INSTANCE_ACCESS_KEY:
                handle_add_instance_ssh_pubkey_command()

            elif choice == AppChoice.DELETE_INSTANCE:
                handle_delete_instances_command()

            elif choice == AppChoice.EXIT:
                break

            print()

        except KeyboardInterrupt:
            print("\nGoodbye...")
            break


if __name__ == "__main__":
    main()

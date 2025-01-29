from enum import Enum

from InquirerPy.base.control import Choice
from InquirerPy.separator import Separator


class AppChoice(Enum):
    CREATE_INSTANCE = 1
    GET_INSTANCES_INFO = 2
    GET_INSTANCE_INFO = 3
    UPDATE_INSTANCE_ACCESS_KEY = 4
    DELETE_INSTANCE = 5
    EXIT = 6
    UNKNOWN = 7


choices = [
    Choice(value=AppChoice.CREATE_INSTANCE, name="Create a VM instance"),
    Choice(value=AppChoice.GET_INSTANCES_INFO, name="Get information about instances"),
    Choice(
        value=AppChoice.GET_INSTANCE_INFO, name="Get information about one instance"
    ),
    Choice(
        value=AppChoice.UPDATE_INSTANCE_ACCESS_KEY,
        name="Change access key to VM instance",
    ),
    Choice(
        value=AppChoice.DELETE_INSTANCE,
        name="Delete instance",
    ),
    Separator(),
    Choice(value=AppChoice.EXIT, name="Exit"),
]

import http.client
import json
import os
import sys
import urllib.parse
from enum import Enum
from http import HTTPStatus
from pathlib import Path
from typing import Any

from ..utils import load_json_from_file


class HttpMethod(str, Enum):
    GET = "GET"
    POST = "POST"
    DELETE = "DELETE"


def send_request_to_yc_intstances(
    add_to_basic_url: str | None = None,
    body: Any | None = None,
    method: HttpMethod = HttpMethod.GET,
    params: Any | None = None,
) -> tuple[HTTPStatus | None, str | None]:
    headers = {
        "Authorization": f"Bearer {os.getenv('IAM_TOKEN') or 'empty_iam_token'}",
    }
    if body is not None:
        headers["Content-Type"] = "application/json"

    url = "/compute/v1/instances" + (
        "" if add_to_basic_url is None else "/" + add_to_basic_url
    )

    if params:
        url += "?" + urllib.parse.urlencode(params)

    try:
        conn = http.client.HTTPSConnection("compute.api.cloud.yandex.net")
        conn.request(
            method.value,
            url,
            body=json.dumps(body) if body else None,
            headers=headers,
        )
        response = conn.getresponse()
        status_code = response.status
        response_data = response.read().decode("utf-8")
        conn.close()
        return (HTTPStatus(status_code), response_data)
    except Exception as e:
        print(f"An error occurred in requesting yc instances: {e}", file=sys.stderr)
        return None, None


def create_yc_vm_instance(name: str) -> tuple[HTTPStatus | None, str | None]:
    create_yc_vm_body = load_json_from_file(
        Path("yandex_cloud_helper/api/request_body/create_instance.json")
    )
    create_yc_vm_body["name"] = name  # type: ignore

    status, result = send_request_to_yc_intstances(
        method=HttpMethod.POST, body=create_yc_vm_body
    )

    return (status, result)


def get_list_yc_vm_instances(folder_id: str) -> tuple[HTTPStatus | None, str | None]:
    return send_request_to_yc_intstances(
        method=HttpMethod.GET, params={"folderId": folder_id}
    )


def get_yc_vm_instance(instance_id: str) -> tuple[HTTPStatus | None, str | None]:
    return send_request_to_yc_intstances(
        method=HttpMethod.GET, add_to_basic_url=instance_id, params={"view": "FULL"}
    )


def update_yc_vm_instance_user_data(
    instance_id: str,
    user_data: str,
) -> tuple[HTTPStatus | None, str | None]:
    return send_request_to_yc_intstances(
        method=HttpMethod.POST,
        add_to_basic_url=instance_id + "/updateMetadata",
        body={"upsert": {"user-data": user_data}},
    )


def delete_yc_vm_instance(instance_id: str) -> tuple[HTTPStatus | None, str | None]:
    return send_request_to_yc_intstances(
        method=HttpMethod.DELETE, add_to_basic_url=instance_id
    )

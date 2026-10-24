import os
from pathlib import Path
import subprocess

import pytest


ROOT = Path(__file__).resolve().parents[1]
PLAYBOOKS = sorted(
    playbook
    for playbook_dir in (ROOT / "install", ROOT / "maintenance")
    if playbook_dir.is_dir()
    for playbook in playbook_dir.glob("playbook_*.yml")
)
ANSIBLE_LINT_EXCLUDED_ROLES = []


@pytest.fixture(scope="module")
def ansible_config(tmp_path_factory):
    config_path = tmp_path_factory.mktemp("ansible-config") / "ansible.cfg"
    config_path.write_text("[defaults]\nvars_plugins_enabled =\n", encoding="utf-8")
    return config_path


@pytest.mark.parametrize("playbook", PLAYBOOKS, ids=lambda playbook: playbook.stem)
def test_ansible_playbook_syntax_check(playbook, ansible_config):
    env = os.environ.copy()
    env["ANSIBLE_CONFIG"] = str(ansible_config)
    env.pop("ANSIBLE_VAULT_PASSWORD_FILE", None)
    result = subprocess.run(
        [
            "ansible-playbook",
            "--inventory",
            "localhost,",
            "--syntax-check",
            str(playbook),
        ],
        cwd=ROOT,
        env=env,
        capture_output=True,
        text=True,
        check=False,
    )

    assert result.returncode == 0, (
        f"{playbook.relative_to(ROOT)} failed syntax check:\n"
        f"stdout:\n{result.stdout}\nstderr:\n{result.stderr}"
    )


def test_ansible_module_arguments_are_compatible(ansible_config):
    command = [
        "ansible-lint",
        "--offline",
        "--profile",
        "min",
        "--enable-list",
        "args",
    ]
    for role in ANSIBLE_LINT_EXCLUDED_ROLES:
        command.extend(["--exclude", role])
    command.extend(str(playbook.relative_to(ROOT)) for playbook in PLAYBOOKS)

    env = os.environ.copy()
    env["ANSIBLE_CONFIG"] = str(ansible_config)
    env.pop("ANSIBLE_VAULT_PASSWORD_FILE", None)
    result = subprocess.run(
        command,
        cwd=ROOT,
        env=env,
        capture_output=True,
        text=True,
        check=False,
    )

    assert result.returncode == 0, (
        f"ansible-lint failed module argument validation:\n"
        f"stdout:\n{result.stdout}\nstderr:\n{result.stderr}"
    )
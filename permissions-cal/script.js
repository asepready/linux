function calculatePermission() {
    let owner = document.getElementById('owner').value;
    let group = document.getElementById('group').value;
    let others = document.getElementById('others').value;

    owner = owner === '' ? 0 : owner;
    group = group === '' ? 0 : group;
    others = others === '' ? 0 : others;

    const permission = `${owner}${group}${others}`;
    const permissionDescription = getPermissionDescription(owner) + getPermissionDescription(group) + getPermissionDescription(others);

    document.getElementById('result').innerText = `Permission: ${permission} (${permissionDescription})`;
}

function getPermissionDescription(value) {
    switch (parseInt(value)) {
        case 0: return '---';
        case 1: return '--x';
        case 2: return '-w-';
        case 3: return '-wx';
        case 4: return 'r--';
        case 5: return 'r-x';
        case 6: return 'rw-';
        case 7: return 'rwx';
        default: return '';
    }
}
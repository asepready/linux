function calculatePermission() {
    let owner = document.getElementById('owner').value;
    let group = document.getElementById('group').value;
    let others = document.getElementById('others').value;

    // Jika input kosong, isi dengan 0
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

function convertSymbolicToNumeric(symbolic) {
    const permissions = {
        'r': 4,
        'w': 2,
        'x': 1,
        '-': 0
    };

    let numeric = 0;
    for (let i = 0; i < symbolic.length; i++) {
        numeric += permissions[symbolic[i]];
    }
    return numeric;
}

function symbolicToNumeric(symbolic) {
    if (symbolic.length !== 9) {
        alert('Invalid permission format');
        return;
    }

    const owner = convertSymbolicToNumeric(symbolic.slice(0, 3));
    const group = convertSymbolicToNumeric(symbolic.slice(3, 6));
    const others = convertSymbolicToNumeric(symbolic.slice(6, 9));

    const numericPermission = `${owner}${group}${others}`;
    document.getElementById('result').innerText = `Numeric Permission: ${numericPermission}`;
}

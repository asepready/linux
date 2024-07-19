function calculate() {
    const cidr = document.getElementById('cidr').value;
    const resultDiv = document.getElementById('result');

    // Simple validation
    if (!cidr.includes('/')) {
        resultDiv.innerHTML = '<p style="color: red;">Harap masukkan alamat IP/CIDR yang valid.</p>';
        return;
    }

    const [ip, prefixLength] = cidr.split('/');
    const ipParts = ip.split('.').map(Number);
    const subnetMask = (0xFFFFFFFF << (32 - prefixLength)) >>> 0;
    const subnetParts = [
        (subnetMask >>> 24) & 0xFF,
        (subnetMask >>> 16) & 0xFF,
        (subnetMask >>> 8) & 0xFF,
        subnetMask & 0xFF
    ];

    const networkParts = ipParts.map((part, index) => part & subnetParts[index]);
    const broadcastParts = ipParts.map((part, index) => part | (~subnetParts[index] & 255));

    const networkAddress = networkParts.join('.');
    const broadcastAddress = broadcastParts.join('.');

    // Determine IP class
    let ipClass = '';
    if (ipParts[0] >= 1 && ipParts[0] <= 126) {
        ipClass = 'A';
    } else if (ipParts[0] >= 128 && ipParts[0] <= 191) {
        ipClass = 'B';
    } else if (ipParts[0] >= 192 && ipParts[0] <= 223) {
        ipClass = 'C';
    } else if (ipParts[0] >= 224 && ipParts[0] <= 239) {
        ipClass = 'D';
    } else if (ipParts[0] >= 240 && ipParts[0] <= 255) {
        ipClass = 'E';
    }

    // Check if IP is public or private
    let ipType = 'Public';
    if (
        (ipParts[0] === 10) ||
        (ipParts[0] === 172 && ipParts[1] >= 16 && ipParts[1] <= 31) ||
        (ipParts[0] === 192 && ipParts[1] === 168)
    ) {
        ipType = 'Private';
    }

    resultDiv.innerHTML = `
        <p>Alamat Jaringan: ${networkAddress}</p>
        <p>Alamat Broadcast: ${broadcastAddress}</p>
        <p>Subnet Mask: ${subnetParts.join('.')}</p>
        <p>Kelas IP: ${ipClass}</p>
        <p>Jenis IP: ${ipType}</p>
    `;
}
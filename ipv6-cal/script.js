document.getElementById('ipv6Address').addEventListener('input', calculateSubnet);
document.getElementById('prefixLength').addEventListener('input', calculateSubnet);
document.getElementById('ipAddress').addEventListener('input', convertIP);
document.getElementById('conversionType').addEventListener('change', convertIP);

function calculateSubnet() {
    const ipv6Address = document.getElementById('ipv6Address').value;
    const prefixLength = document.getElementById('prefixLength').value;
    const resultDiv = document.getElementById('result');

    if (!ipv6Address || !prefixLength) {
        resultDiv.innerHTML = 'Please enter both IPv6 address and prefix length.';
        return;
    }

    // Simple validation for IPv6 address format
    const ipv6Pattern = /^([0-9a-fA-F]{1,4}:){7}[0-9a-fA-F]{1,4}$/;
    if (!ipv6Pattern.test(ipv6Address)) {
        resultDiv.innerHTML = 'Invalid IPv6 address format.';
        return;
    }

    // Calculate subnet and network prefix
    const subnet = ipv6Address.split(':').slice(0, prefixLength / 16).join(':');
    const networkPrefix = `${subnet}::/${prefixLength}`;

    // Determine if the IP is public or private
    const isPrivate = isPrivateIPv6(ipv6Address);

    resultDiv.innerHTML = `<p>Subnet: ${subnet}</p><p>Network Prefix: ${networkPrefix}</p><p>Type: ${isPrivate ? 'Private' : 'Public'}</p>`;
}

function isPrivateIPv6(ip) {
    // Check if the IPv6 address is within the private range
    const privateRanges = [
        'fc00::/7', // Unique Local Address (ULA)
        'fe80::/10' // Link-Local Address
    ];

    for (const range of privateRanges) {
        const [rangeAddress, prefixLength] = range.split('/');
        if (isInRange(ip, rangeAddress, parseInt(prefixLength))) {
            return true;
        }
    }
    return false;
}

function isInRange(ip, rangeAddress, prefixLength) {
    const ipBits = ipToBits(ip);
    const rangeBits = ipToBits(rangeAddress);
    return ipBits.slice(0, prefixLength) === rangeBits.slice(0, prefixLength);
}

function ipToBits(ip) {
    return ip.split(':').map(part => parseInt(part, 16).toString(2).padStart(16, '0')).join('');
}

function convertIP() {
    const ipAddress = document.getElementById('ipAddress').value;
    const conversionType = document.getElementById('conversionType').value;
    const conversionResultDiv = document.getElementById('conversionResult');

    if (!ipAddress) {
        conversionResultDiv.innerHTML = 'Please enter an IP address.';
        return;
    }

    let result;
    switch (conversionType) {
        case 'ipv4toipv6':
            result = ipv4ToIpv6(ipAddress);
            conversionResultDiv.innerHTML = `<p>IPv6 Address: ${result}</p>`;
            break;
        case 'ipv6toipv4':
            result = ipv6ToIpv4(ipAddress);
            conversionResultDiv.innerHTML = `<p>IPv4 Address: ${result}</p>`;
            break;
        case 'ipv4cidrtoipv6':
            result = ipv4CidrToIpv6(ipAddress);
            conversionResultDiv.innerHTML = `<p>IPv6 Network Prefix: ${result}</p>`;
            break;
        case 'ipv6cidrtoipv4':
            result = ipv6CidrToIpv4(ipAddress);
            conversionResultDiv.innerHTML = `<p>IPv4 CIDR: ${result}</p>`;
            break;
        default:
            conversionResultDiv.innerHTML = 'Invalid conversion type.';
    }
}

function ipv4ToIpv6(ipv4) {
    const parts = ipv4.split('.').map(part => parseInt(part, 10).toString(16).padStart(2, '0'));
    return `::ffff:${parts.join('')}`;
}

function ipv6ToIpv4(ipv6) {
    if (ipv6.startsWith('::ffff:')) {
        const hex = ipv6.slice(7);
        const parts = [];
        for (let i = 0; i < hex.length; i += 2) {
            parts.push(parseInt(hex.slice(i, i + 2), 16));
        }
        return parts.join('.');
    }
    return 'Invalid IPv6 address for conversion';
}

function ipv4CidrToIpv6(ipv4Cidr) {
    const [ipv4, cidr] = ipv4Cidr.split('/');
    const ipv6 = ipv4ToIpv6(ipv4);
    return `${ipv6}/${parseInt(cidr) + 96}`;
}

function ipv6CidrToIpv4(ipv6Cidr) {
    const [ipv6, cidr] = ipv6Cidr.split('/');
    if (ipv6.startsWith('::ffff:')) {
        const ipv4 = ipv6ToIpv4(ipv6);
        return `${ipv4}/${parseInt(cidr) - 96}`;
    }
    return 'Invalid IPv6 address for conversion';
}

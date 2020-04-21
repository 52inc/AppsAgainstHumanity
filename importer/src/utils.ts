const crypto = require('crypto');

export function cleanPath(input: string): string {
    return input.replace('/', '_');
}

export function computeCardId(set: string, cardText: string): string {
    const hash = crypto.createHash('sha256');
    hash.update(set + cardText);
    return hash.digest('hex');
}

export function hashDocumentId(input: string): string {
    const hash = crypto.createHash('sha256');
    hash.update(input);
    return hash.digest('hex');
}
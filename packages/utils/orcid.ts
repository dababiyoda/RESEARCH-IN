const ORCID_PATTERN = /^\d{4}-\d{4}-\d{4}-\d{3}[\dX]$/;

/**
 * Validate an ORCID using the ISO 7064 mod 11-2 checksum algorithm.
 *
 * More info: https://info.orcid.org/faq/what-is-an-orcid-identifier/
 */
export function isValidOrcid(orcid: string): boolean {
  if (!ORCID_PATTERN.test(orcid)) return false;

  const digits = orcid.replace(/-/g, '').split('');
  const checkDigit = digits.pop();

  const total = digits.reduce((acc, digit) => (acc + Number(digit)) * 2, 0);
  const remainder = total % 11;
  const result = (12 - remainder) % 11;
  const expected = result === 10 ? 'X' : String(result);

  return checkDigit === expected;
}

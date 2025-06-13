export function userWeight(user: { phd: boolean; orcidVerified: boolean }) {
  let weight = 1;
  if (user.phd) weight += 1;
  if (user.orcidVerified) weight += 1;
  return weight;
}

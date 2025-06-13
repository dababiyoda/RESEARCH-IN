import express from 'express';
import jwt from 'jsonwebtoken';
import { userWeight } from '@open-research-nexus/utils/priority';

const app = express();
app.use(express.json());

// Simple JWT auth middleware
function auth(req: express.Request, res: express.Response, next: express.NextFunction) {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) return res.sendStatus(401);
  try {
    (req as any).user = jwt.verify(token, 'secret');
    next();
  } catch {
    res.sendStatus(401);
  }
}

// ORCID validation middleware
function validateOrcid(req: express.Request, res: express.Response, next: express.NextFunction) {
  const orcid = req.body.orcid as string;
  if (!/^\d{4}-\d{4}-\d{4}-\d{4}$/.test(orcid)) {
    return res.status(400).json({ error: 'Invalid ORCID format' });
  }
  next();
}

app.post('/verify-orcid', auth, validateOrcid, (req, res) => {
  const user = (req as any).user as { phd: boolean };
  const weight = userWeight({ phd: user.phd, orcidVerified: true });
  res.json({ verified: true, weight });
});

app.get('/papers/:id/comments', auth, (req, res) => {
  const user = (req as any).user as { phd: boolean; orcidVerified: boolean };
  const weight = userWeight(user);
  res.json({ paperId: req.params.id, comments: [], weight });
});

if (require.main === module) {
  app.listen(3001, () => console.log('community service running'));
}

export default app;

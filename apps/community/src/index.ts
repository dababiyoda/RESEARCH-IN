import express from 'express';
import jwt from 'jsonwebtoken';
import { isValidOrcid, userWeight } from '@open-research-nexus/utils';

const JWT_SECRET = process.env.JWT_SECRET || 'development-secret';

const app = express();
app.use(express.json());

// Simple JWT auth middleware
function auth(req: express.Request, res: express.Response, next: express.NextFunction) {
  const token = req.headers.authorization?.split(' ')[1];
  if (!token) return res.sendStatus(401);
  try {
    (req as any).user = jwt.verify(token, JWT_SECRET);
    next();
  } catch {
    res.sendStatus(401);
  }
}

// ORCID validation middleware
function validateOrcid(req: express.Request, res: express.Response, next: express.NextFunction) {
  const orcid = req.body.orcid as string;
  if (typeof orcid !== 'string' || !isValidOrcid(orcid)) {
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

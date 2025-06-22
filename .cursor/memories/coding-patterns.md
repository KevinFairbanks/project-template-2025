# Coding Patterns Memory

## 🏗️ Preferred Architecture Patterns

### API Structure
```javascript
// Preferred route structure
app.use('/api/v1/users', userRoutes);
app.use('/api/v1/auth', authRoutes);
app.use('/api/v1/admin', adminRoutes);

// Controller pattern
const userController = {
  async getUsers(req, res, next) {
    try {
      const users = await userService.getAllUsers();
      res.json({ success: true, data: users });
    } catch (error) {
      next(error);
    }
  }
};
```

### Error Handling Pattern
```javascript
// Centralized error handling middleware
const errorHandler = (err, req, res, next) => {
  const { statusCode = 500, message } = err;

  logger.error(err.stack);

  res.status(statusCode).json({
    success: false,
    error: {
      message: process.env.NODE_ENV === 'production'
        ? 'Internal Server Error'
        : message,
      ...(process.env.NODE_ENV !== 'production' && { stack: err.stack })
    }
  });
};
```

### Database Patterns
```javascript
// Use connection pooling
const pool = new Pool({
  connectionString: process.env.DATABASE_URL,
  max: 20,
  idleTimeoutMillis: 30000,
  connectionTimeoutMillis: 2000,
});

// Transaction pattern
const transferFunds = async (fromId, toId, amount) => {
  const client = await pool.connect();
  try {
    await client.query('BEGIN');

    await client.query(
      'UPDATE accounts SET balance = balance - $1 WHERE id = $2',
      [amount, fromId]
    );

    await client.query(
      'UPDATE accounts SET balance = balance + $1 WHERE id = $2',
      [amount, toId]
    );

    await client.query('COMMIT');
  } catch (error) {
    await client.query('ROLLBACK');
    throw error;
  } finally {
    client.release();
  }
};
```

## 🔒 Security Patterns

### Input Validation
```javascript
// Use Joi for validation
const userSchema = Joi.object({
  email: Joi.string().email().required(),
  password: Joi.string().min(8).required(),
  name: Joi.string().min(2).max(50).required()
});

const validateUser = (req, res, next) => {
  const { error } = userSchema.validate(req.body);
  if (error) {
    return res.status(400).json({
      success: false,
      error: error.details[0].message
    });
  }
  next();
};
```

### Authentication Pattern
```javascript
// JWT middleware
const authenticateToken = (req, res, next) => {
  const authHeader = req.headers['authorization'];
  const token = authHeader && authHeader.split(' ')[1];

  if (!token) {
    return res.status(401).json({
      success: false,
      error: 'Access token required'
    });
  }

  jwt.verify(token, process.env.JWT_SECRET, (err, user) => {
    if (err) {
      return res.status(403).json({
        success: false,
        error: 'Invalid token'
      });
    }
    req.user = user;
    next();
  });
};
```

## 📊 Testing Patterns

### Unit Test Structure
```javascript
describe('UserService', () => {
  describe('createUser', () => {
    it('should create a user with valid data', async () => {
      // Arrange
      const userData = {
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User'
      };

      // Act
      const result = await userService.createUser(userData);

      // Assert
      expect(result).toBeDefined();
      expect(result.email).toBe(userData.email);
      expect(result.password).not.toBe(userData.password); // Should be hashed
    });

    it('should throw error with invalid email', async () => {
      // Arrange
      const userData = {
        email: 'invalid-email',
        password: 'password123',
        name: 'Test User'
      };

      // Act & Assert
      await expect(userService.createUser(userData))
        .rejects
        .toThrow('Invalid email format');
    });
  });
});
```

### Integration Test Pattern
```javascript
describe('POST /api/v1/users', () => {
  beforeEach(async () => {
    await setupTestDatabase();
  });

  afterEach(async () => {
    await cleanupTestDatabase();
  });

  it('should create user and return 201', async () => {
    const response = await request(app)
      .post('/api/v1/users')
      .send({
        email: 'test@example.com',
        password: 'password123',
        name: 'Test User'
      })
      .expect(201);

    expect(response.body.success).toBe(true);
    expect(response.body.data.email).toBe('test@example.com');
  });
});
```

## 🎨 Frontend Patterns (if applicable)

### Component Structure
```javascript
// Functional component with hooks
const UserProfile = ({ userId }) => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(true);
  const [error, setError] = useState(null);

  useEffect(() => {
    const fetchUser = async () => {
      try {
        setLoading(true);
        const response = await api.get(`/users/${userId}`);
        setUser(response.data);
      } catch (err) {
        setError(err.message);
      } finally {
        setLoading(false);
      }
    };

    fetchUser();
  }, [userId]);

  if (loading) return <LoadingSpinner />;
  if (error) return <ErrorMessage message={error} />;
  if (!user) return <NotFound />;

  return (
    <div className="user-profile">
      <h1>{user.name}</h1>
      <p>{user.email}</p>
    </div>
  );
};
```

## 🚀 Performance Patterns

### Caching Strategy
```javascript
// Redis caching pattern
const getUser = async (id) => {
  const cacheKey = `user:${id}`;

  // Try cache first
  const cached = await redis.get(cacheKey);
  if (cached) {
    return JSON.parse(cached);
  }

  // Fetch from database
  const user = await db.user.findById(id);

  // Cache for 1 hour
  await redis.setex(cacheKey, 3600, JSON.stringify(user));

  return user;
};
```

### Database Query Optimization
```javascript
// Use select to limit fields
const getUsers = async (limit = 10, offset = 0) => {
  return await db.user.findMany({
    select: {
      id: true,
      name: true,
      email: true,
      createdAt: true
    },
    take: limit,
    skip: offset,
    orderBy: { createdAt: 'desc' }
  });
};
```

## 🔧 Configuration Patterns

### Environment Configuration
```javascript
// config/index.js
const config = {
  port: process.env.PORT || 3000,
  database: {
    url: process.env.DATABASE_URL,
    ssl: process.env.NODE_ENV === 'production'
  },
  redis: {
    url: process.env.REDIS_URL || 'redis://localhost:6379'
  },
  jwt: {
    secret: process.env.JWT_SECRET,
    expiresIn: process.env.JWT_EXPIRES_IN || '24h'
  }
};

module.exports = config;
```

## 📝 Documentation Patterns

### Function Documentation
```javascript
/**
 * Creates a new user account
 * @param {Object} userData - User registration data
 * @param {string} userData.email - User's email address
 * @param {string} userData.password - User's password (will be hashed)
 * @param {string} userData.name - User's full name
 * @returns {Promise<Object>} Created user object (without password)
 * @throws {ValidationError} When input data is invalid
 * @throws {ConflictError} When email already exists
 */
const createUser = async (userData) => {
  // Implementation
};
```

### API Documentation Pattern
```javascript
/**
 * @swagger
 * /api/v1/users:
 *   post:
 *     summary: Create a new user
 *     tags: [Users]
 *     requestBody:
 *       required: true
 *       content:
 *         application/json:
 *           schema:
 *             type: object
 *             required:
 *               - email
 *               - password
 *               - name
 *             properties:
 *               email:
 *                 type: string
 *                 format: email
 *               password:
 *                 type: string
 *                 minLength: 8
 *               name:
 *                 type: string
 *                 minLength: 2
 *     responses:
 *       201:
 *         description: User created successfully
 *       400:
 *         description: Invalid input data
 *       409:
 *         description: Email already exists
 */
```

## 🎯 Code Style Preferences

### Naming Conventions
- **Variables**: camelCase (`userName`, `isActive`)
- **Functions**: camelCase (`getUserById`, `validateInput`)
- **Constants**: UPPER_SNAKE_CASE (`MAX_RETRIES`, `DEFAULT_TIMEOUT`)
- **Classes**: PascalCase (`UserService`, `DatabaseConnection`)
- **Files**: kebab-case (`user-service.js`, `auth-middleware.js`)

### Code Organization
- **Group related functions** together
- **Use descriptive variable names** over comments when possible
- **Keep functions small** and focused on single responsibility
- **Use early returns** to reduce nesting
- **Prefer async/await** over callbacks or raw promises

Remember these patterns and apply them consistently across the project!

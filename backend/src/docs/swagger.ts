export const swaggerDocument = {
  openapi: '3.0.0',
  info: {
    title: 'SecureByPay Assessment API',
    version: '1.0.0',
    description: 'REST API documentation for SecureByPay Logistics & Payment application.',
  },
  servers: [
    {
      url: '/api',
      description: 'API base path',
    },
  ],
  components: {
    securitySchemes: {
      BearerAuth: {
        type: 'http',
        scheme: 'bearer',
        bearerFormat: 'JWT',
      },
    },
    schemas: {
      RegisterRequest: {
        type: 'object',
        required: ['firstName', 'lastName', 'email', 'phone', 'password'],
        properties: {
          firstName: { type: 'string', example: 'John' },
          lastName: { type: 'string', example: 'Doe' },
          email: { type: 'string', format: 'email', example: 'john.doe@example.com' },
          phone: { type: 'string', example: '+2348012345678' },
          password: { type: 'string', minLength: 6, example: 'Secret123!' },
        },
      },
      LoginRequest: {
        type: 'object',
        required: ['email', 'password'],
        properties: {
          email: { type: 'string', format: 'email', example: 'john.doe@example.com' },
          password: { type: 'string', example: 'Secret123!' },
        },
      },
      FundWalletRequest: {
        type: 'object',
        required: ['amount'],
        properties: {
          amount: { type: 'number', example: 50000 },
        },
      },
      ApiResponse: {
        type: 'object',
        properties: {
          success: { type: 'boolean' },
          message: { type: 'string' },
          data: { type: 'object' },
        },
      },
      ApiError: {
        type: 'object',
        properties: {
          success: { type: 'boolean', example: false },
          error: { type: 'string' },
          details: { type: 'object' },
        },
      },
    },
  },
  paths: {
    '/auth/register': {
      post: {
        tags: ['Authentication'],
        summary: 'Register a new user account',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: { $ref: '#/components/schemas/RegisterRequest' },
            },
          },
        },
        responses: {
          201: {
            description: 'User registered successfully with JWT',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/ApiResponse' } } },
          },
          400: {
            description: 'Validation error or duplicate email',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/ApiError' } } },
          },
        },
      },
    },
    '/auth/login': {
      post: {
        tags: ['Authentication'],
        summary: 'Authenticate user with email and password',
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: { $ref: '#/components/schemas/LoginRequest' },
            },
          },
        },
        responses: {
          200: {
            description: 'Logged in successfully with JWT',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/ApiResponse' } } },
          },
          401: {
            description: 'Invalid email or password',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/ApiError' } } },
          },
        },
      },
    },
    '/auth/me': {
      get: {
        tags: ['Authentication'],
        summary: 'Retrieve authenticated user profile',
        security: [{ BearerAuth: [] }],
        responses: {
          200: {
            description: 'Current user profile',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/ApiResponse' } } },
          },
          401: { description: 'Unauthorized' },
        },
      },
    },
    '/dashboard/overview': {
      get: {
        tags: ['Dashboard'],
        summary: 'Fetch overview statistics and wallet balance',
        security: [{ BearerAuth: [] }],
        responses: {
          200: {
            description: 'Overview data',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/ApiResponse' } } },
          },
        },
      },
    },
    '/dashboard/growth': {
      get: {
        tags: ['Dashboard'],
        summary: 'Fetch company growth chart points',
        parameters: [
          {
            name: 'period',
            in: 'query',
            required: false,
            schema: { type: 'string', enum: ['Year', 'Month', 'Week'], default: 'Year' },
          },
        ],
        responses: {
          200: {
            description: 'Chart coordinates and labels',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/ApiResponse' } } },
          },
        },
      },
    },
    '/dashboard/shipments': {
      get: {
        tags: ['Dashboard'],
        summary: 'Fetch list of recent shipments',
        responses: {
          200: {
            description: 'List of shipments',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/ApiResponse' } } },
          },
        },
      },
    },
    '/dashboard/wallet/fund': {
      post: {
        tags: ['Dashboard'],
        summary: 'Fund user wallet',
        security: [{ BearerAuth: [] }],
        requestBody: {
          required: true,
          content: {
            'application/json': {
              schema: { $ref: '#/components/schemas/FundWalletRequest' },
            },
          },
        },
        responses: {
          200: {
            description: 'Wallet funded successfully',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/ApiResponse' } } },
          },
        },
      },
    },
    '/dashboard/shipments/{id}/pay': {
      post: {
        tags: ['Dashboard'],
        summary: 'Pay for an in-transit or delayed shipment',
        security: [{ BearerAuth: [] }],
        parameters: [
          {
            name: 'id',
            in: 'path',
            required: true,
            schema: { type: 'string' },
          },
        ],
        responses: {
          200: {
            description: 'Shipment marked as paid',
            content: { 'application/json': { schema: { $ref: '#/components/schemas/ApiResponse' } } },
          },
          400: { description: 'Already paid or insufficient balance' },
          404: { description: 'Shipment not found' },
        },
      },
    },
  },
};

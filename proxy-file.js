module.exports = [
    {
      path: '/api',
      rule: { 
        target: 'http://173.212.238.198:5000',
        pathRewrite: {'^/api' : ''}
      }
    }
  ]
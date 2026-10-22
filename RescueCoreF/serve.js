const http = require('http');
const fs = require('fs');
const path = require('path');

const PORT = process.env.PORT || 8081;
const WEB_DIR = path.join(__dirname, 'build', 'web');

const MIME = {
  '.html': 'text/html; charset=utf-8',
  '.js': 'text/javascript; charset=utf-8',
  '.css': 'text/css; charset=utf-8',
  '.json': 'application/json',
  '.png': 'image/png',
  '.jpg': 'image/jpeg',
  '.svg': 'image/svg+xml',
  '.wasm': 'application/wasm',
  '.ttf': 'font/ttf',
  '.otf': 'font/otf',
  '.woff': 'font/woff',
  '.woff2': 'font/woff2'
};

if (!fs.existsSync(WEB_DIR)) {
  console.error(`[ERROR] Build folder not found at: ${WEB_DIR}`);
  console.error('Run "flutter build web" first.');
  process.exit(1);
}

const server = http.createServer((req, res) => {
  res.setHeader('Access-Control-Allow-Origin', '*');
  let cleanUrl = req.url.split('?')[0];
  let filePath = path.join(WEB_DIR, cleanUrl === '/' ? 'index.html' : cleanUrl);

  if (fs.existsSync(filePath) && fs.statSync(filePath).isDirectory()) {
    filePath = path.join(filePath, 'index.html');
  }

  if (!fs.existsSync(filePath)) {
    filePath = path.join(WEB_DIR, 'index.html');
  }

  const ext = path.extname(filePath).toLowerCase();
  res.setHeader('Content-Type', MIME[ext] || 'application/octet-stream');
  fs.createReadStream(filePath).pipe(res);
});

server.on('error', (err) => {
  if (err.code === 'EADDRINUSE') {
    console.log(`[OK] Port ${PORT} is already running!`);
  } else {
    console.error(`[ERROR] Server error:`, err.message);
  }
});

server.listen(PORT, '0.0.0.0', () => {
  console.log('===========================================================');
  console.log(`📱 Citizen Emergency App (RescueCoreF) Local Web Server`);
  console.log(`🚀 URL: http://localhost:${PORT}`);
  console.log(`📡 Connected Backend: http://localhost:5000`);
  console.log('===========================================================');
});

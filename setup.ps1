<#
  setup.ps1
  Scaffold ClimateVis client + server, install deps, open VS Code
#>

# -- 1) CLIENT: React + Tailwind --
Write-Host "⏳ Scaffolding React client..."
# Create client folder
mkdir client
Push-Location client

# Scaffold CRA with TypeScript
npx create-react-app . --template typescript

# Install TailwindCSS
npm install -D tailwindcss postcss autoprefixer
npx tailwindcss init -p

# Inject minimal Tailwind config (appends to tailwind.config.js)
@"
module.exports = {
  content: ['./src/**/*.{js,jsx,ts,tsx}', './public/index.html'],
  theme: { extend: {} },
  plugins: [],
};
"@ | Out-File -Encoding utf8 tailwind.config.js -Append

# Update src/index.css to include Tailwind directives
@"
@tailwind base;
@tailwind components;
@tailwind utilities;
"@ | Out-File -Encoding utf8 src/index.css

Pop-Location


# -- 2) SERVER: Node + Express --
Write-Host "⏳ Scaffolding Express server..."
mkdir server
Push-Location server

# Initialize npm & install
npm init -y
npm install express cors dotenv node-fetch@2

# Dev helper
npm install -D nodemon

# Create basic .env.example
@"
# copy to .env and fill in your NASA key
NASA_API_KEY=your_api_key_here
PORT=4000
"@ | Out-File -Encoding utf8 .env.example

# Create index.js with a sample /api/earth endpoint
@"
require('dotenv').config();
const express = require('express');
const fetch = require('node-fetch');
const cors = require('cors');

const app = express();
app.use(cors());
const PORT = process.env.PORT || 4000;
const NASA_KEY = process.env.NASA_API_KEY;

app.get('/api/earth', async (req, res) => {
  // Example: fetch EPIC imagery metadata
  const resp = await fetch(\`https://api.nasa.gov/EPIC/api/natural/images?api_key=\${NASA_KEY}\`);
  const data = await resp.json();
  res.json(data);
});

// start
app.listen(PORT, () => console.log(\`🛰️  Server running on http://localhost:\${PORT}\`));
"@ | Out-File -Encoding utf8 index.js

# Add a nodemon dev script to package.json
(Get-Content package.json) -replace
  '"test": "echo \"Error: no test specified\" && exit 1"',
  '"dev": "nodemon index.js",' | 
  Set-Content package.json

Pop-Location


# -- 3) Done! Open in VS Code --
Write-Host "✅ Scaffold complete!"
Write-Host "▶️  cd client   && npm start"
Write-Host "▶️  cd server   && npm run dev"
Write-Host "▶️  code .     (opens this folder in VS Code)"

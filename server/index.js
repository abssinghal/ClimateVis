require('dotenv').config();

const express = require('express');
const fetch = require('node-fetch');
const cors = require('cors');

const app = express();
app.use(cors());
const PORT = process.env.PORT || 4000;
const NASA_KEY = process.env.NASA_API_KEY;

app.get('/api/epic', async (req, res) => {
  try {
    const response = await fetch(
      `https://api.nasa.gov/EPIC/api/natural/images?api_key=${NASA_KEY}`
    );
    const data = await response.json();
    res.json(data);
  } catch (err) {
    console.error(err);
    res.status(500).json({ error: 'Failed to fetch EPIC images' });
  }
});


// start
app.listen(PORT, () => 
  console.log(`🛰️  Server running on http://localhost:${PORT}`)
);
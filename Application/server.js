require('dotenv').config();
const express = require('express');
const mysql = require("mysql2");
const app = express();
const PORT = process.env.PORT || 3000;

app.use(express.json());



// MySQL Connection Pool (using pooling for better performance)
const dbPool = mysql.createPool({
    host: 'localhost',
    user: process.env.DB_USER,
    password: process.env.DB_PASSWORD,
    database: process.env.DB_NAME
});




// check database connection status
function checkDatabaseConnection(callback) {
    dbPool.getConnection((err, connection) =>{
        if(err){
            callback(false,`Database is not working`)
        }
        else{
            callback(true, `Database is working`)
        }
    })

}

// Route: GET /health
app.get("/health", (req, res) => {
    checkDatabaseConnection((isConnected, message) => {

        if (isConnected) {
            res.status(200).json({
                status: 'healthy',
                message: message
            });        }
        else{
            res.status(500).json({
                status: 'healthy',
                message: message
            });
        }
    });
});



// Route: GET /users
app.get("/users", (req, res) => {
    const query = "SELECT * FROM users";
    dbPool.query(query, (err, results) => {
        if (err) {
            console.error("Error fetching users:", err);
            return res.status(500).json({ error: "Database query error" });
        }
        res.json(results);
    });
});



// Start Server
app.listen(PORT, () => {
    console.log(`Server running on : http://localhost:${PORT}`);
});

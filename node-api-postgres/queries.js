const fs = require('fs')
const Pool = require('pg').Pool
const pool = new Pool({
  host: process.env.HOST || 'cockroachdb-public',
  database: process.env.DATABASE || 'taxi_trips',
  port: process.env.DBPORT || 26257,
  user: process.env.PGUSER || 'root',  
  ssl: {
    rejectUnauthorized: false,
    ca: fs.readFileSync('/cockroach-certs/ca.crt').toString(),
    key: fs.readFileSync('/cockroach-certs/client.root.key').toString(),
    cert: fs.readFileSync('/cockroach-certs/client.root.crt').toString(),
  },  
})

// trip_miles 0-3220

const getUserById = (request, response) => {
  const id = parseInt(request.params.id)

  pool.query('SELECT count(*) FROM taxi_trips WHERE trip_miles = $1', [id], (error, results) => {
    if (error) {
      throw error
    }
    response.status(200).json(results.rows)
  })
}

module.exports = {
  getUserById,
}

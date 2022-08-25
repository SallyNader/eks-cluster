const express = require("express");
const app = express();

require("./db")();



app.get("/", (req, res) => {
  res.send("Users Shown");
});

app.listen(3000, function () {
    console.log("listening on 3000");
  });
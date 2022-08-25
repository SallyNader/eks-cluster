const mongoose = require("mongoose");
const MONGODB_URL = "mongodb://mongodb-service";



module.exports = function () {
  mongoose.connect(MONGODB_URL, {
    useUnifiedTopology: true,
    useNewUrlParser: true,
  });

  mongoose.connection.on("connected", () => {
    console.log("Connect to MongoDB");
  });

  mongoose.connection.on("error", (err) => {
    console.log(`Error ${err}`);
  });
};
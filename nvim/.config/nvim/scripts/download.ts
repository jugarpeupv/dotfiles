import { chrome } from "@rookie-rs/api";
import fs from "fs";
import { https } from "follow-redirects";
import open, { apps } from "open";

const cookies = chrome();

const curlCookieFlag = cookies
  .filter((c) => c.domain === "github.com" || c.domain === ".github.com")
  .map((c) => `${c.name}=${c.value}`)
  .join("; ");


const loggedInCookie = cookies.find(
  (c) =>
    (c.domain === "github.com" || c.domain === ".github.com") &&
    c.name === "logged_in"
);

if (loggedInCookie && loggedInCookie.value === "no") {
  console.log("You are not logged in to GitHub.");
  await open("https://github.com/enterprises/mapfre/sso", {
    app: {
      name: apps.chrome,
    },
  });
  process.exit(0);
}

const url = process.argv[2];
if (!url) {
  console.error("Usage: bun download.ts <url>");
  process.exit(1);
}

const tmpFile = process.argv[3];
if (!tmpFile) {
  console.error("Usage: bun download.ts <url> <output-file>");
  process.exit(1);
}

const options = {
  headers: {
    Cookie: curlCookieFlag,
    "User-Agent":
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/141.0.0.0 Safari/537.36",
    Accept: "image/avif,image/webp,image/apng,image/svg+xml,image/*,*/*;q=0.8",
    Referer: "https://github.com/",
  },
};

https
  .get(url, options, async (res) => {
    console.log(`Status Code: ${res.statusCode}`);
    const contentType = res.headers["content-type"] || "";
    if (contentType.includes("text/html")) {
      console.error("Response is HTML, likely a login or SSO page.");
      await open("https://github.com/enterprises/mapfre/sso", {
        app: {
          name: apps.chrome,
        },
      });
      // await open('https://github.com/enterprises/mapfre/sso');
      return;
    }
    if (res.statusCode !== 200) {
      console.error(`Request failed: ${res.statusCode}`);
      res.resume();
      return;
    }
    const fileStream = fs.createWriteStream(tmpFile);
    res.pipe(fileStream);
    fileStream.on("finish", () => {
      fileStream.close(() => {
        console.log(tmpFile);
      });
    });
    if (res.statusCode !== 200) {
      console.error(`Request failed: ${res.statusCode}`);
      res.resume();
      return;
    }
  })
  .on("error", (e) => {
    console.error(`Error: ${e.message}`);
  });

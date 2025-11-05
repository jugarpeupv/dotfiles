import fs from "fs";
import { chrome } from "@rookie-rs/api";
import { execSync } from "child_process";
import open, { apps } from "open";

export type Petition1Response = {
  upload_url: string;
  header: Record<string, unknown>;
  asset: {
    id: number;
    name: string;
    size: number;
    content_type: string;
    href: string;
    original_name: string;
  };
  form: {
    key: string;
    acl: string;
    policy: string;
    "X-Amz-Algorithm": string;
    "X-Amz-Credential": string;
    "X-Amz-Date": string;
    "X-Amz-Signature": string;
    "Content-Type": string;
    "Cache-Control": string;
    "x-amz-meta-Surrogate-Control": string;
  };
  same_origin: boolean;
  asset_upload_url: string;
  upload_authenticity_token: string;
  asset_upload_authenticity_token: string;
};

const clipboardImageName = "image.png";
const clipboardImageMimeType = "image/png";

try {
  execSync(`pngpaste ${clipboardImageName}`);
} catch (error) {
  console.error("Error copying image from clipboard:");
  process.exit(0);
}

const clipboardImageStats = fs.statSync(clipboardImageName);

const cookies = chrome();

const curlCookieFlag = cookies
  .filter((c) => c.domain === "github.com" || c.domain === ".github.com")
  .map((c) => `${c.name}=${c.value}`)
  .join("; ");

async function petition1() {
  const randomString = Array.from(
    { length: 16 },
    () => Math.random().toString(36)[2],
  ).join("");

  const boundary = `----WebKitFormBoundary${randomString}`;
  const body =
    `------WebKitFormBoundary${randomString}\r\n` +
    'Content-Disposition: form-data; name="repository_id"\r\n\r\n' +
    "890401049\r\n" +
    `------WebKitFormBoundary${randomString}\r\n` +
    'Content-Disposition: form-data; name="name"\r\n\r\n' +
    `${clipboardImageName}\r\n` +
    `------WebKitFormBoundary${randomString}\r\n` +
    'Content-Disposition: form-data; name="size"\r\n\r\n' +
    `${clipboardImageStats.size}\r\n` +
    `------WebKitFormBoundary${randomString}\r\n` +
    'Content-Disposition: form-data; name="content_type"\r\n\r\n' +
    `${clipboardImageMimeType}\r\n` +
    `------WebKitFormBoundary${randomString}--\r\n`;

  const headers = {
    accept: "*/*",
    "accept-language": "en-GB,en;q=0.5",
    "cache-control": "no-cache",
    "content-type": `multipart/form-data; boundary=${boundary}`,
    "github-verified-fetch": "true",
    origin: "https://github.com",
    pragma: "no-cache",
    priority: "u=1, i",
    // referer: "https://github.com/mapfre-tech/arch-mar2-mgmt/issues/1166",
    "sec-ch-ua": '"Chromium";v="142", "Brave";v="142", "Not_A Brand";v="99"',
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": '"macOS"',
    "sec-fetch-dest": "empty",
    "sec-fetch-mode": "cors",
    "sec-fetch-site": "same-origin",
    "sec-gpc": "1",
    "user-agent":
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36",
    // "x-github-client-version": "6f0a50c83824a7b7b3ed4ac8a758c063075591b0",
    "x-requested-with": "XMLHttpRequest",
    cookie: curlCookieFlag,
  };

  const response = await fetch("https://github.com/upload/policies/assets", {
    method: "POST",
    headers,
    body,
  });

  // console.log("Curl finished with status:", response.status);

  if (response.status !== 201) {
    await open("https://github.com/enterprises/mapfre/sso", {
      app: {
        name: apps.chrome,
      },
    });
    process.exit(0);
  }

  const json = await response.json();
  // fs.writeFileSync("response1.json", JSON.stringify(json, null, 2));
  return json;
}

async function petition2(
  petition1Response: Petition1Response,
  imagePath = "image.png",
) {
  const form = petition1Response.form;
  const uploadUrl = petition1Response.upload_url;

  // Read the image file as a Buffer
  const fileBuffer = fs.readFileSync(imagePath);

  // Build the multipart/form-data body manually
  const randomString = Math.random().toString(36).slice(2, 18);
  const boundary = "----WebKitFormBoundary" + randomString;
  function part(
    name: string,
    value: string | Buffer,
    filename?: string,
    contentType?: string,
  ) {
    let out = `--${boundary}\r\nContent-Disposition: form-data; name="${name}"`;
    if (filename) out += `; filename="${filename}"`;
    out += "\r\n";
    if (contentType) out += `Content-Type: ${contentType}\r\n`;
    out += "\r\n";
    return Buffer.concat([
      Buffer.from(out, "utf8"),
      Buffer.isBuffer(value) ? value : Buffer.from(value, "utf8"),
      Buffer.from("\r\n", "utf8"),
    ]);
  }

  // All fields except file
  const fields = [
    part("key", form.key),
    part("acl", form.acl),
    part("policy", form.policy),
    part("X-Amz-Algorithm", form["X-Amz-Algorithm"]),
    part("X-Amz-Credential", form["X-Amz-Credential"]),
    part("X-Amz-Date", form["X-Amz-Date"]),
    part("X-Amz-Signature", form["X-Amz-Signature"]),
    part("Content-Type", form["Content-Type"]),
    part("Cache-Control", form["Cache-Control"]),
    part("x-amz-meta-Surrogate-Control", form["x-amz-meta-Surrogate-Control"]),
    // file field last
    part(
      "file",
      fileBuffer,
      petition1Response.asset.name,
      form["Content-Type"],
    ),
  ];

  const end = Buffer.from(`--${boundary}--\r\n`, "utf8");
  const bodyBuffer = Buffer.concat([...fields, end]);

  // Prepare headers
  const headers = {
    Accept: "*/*",
    "Accept-Language": "en-GB,en;q=0.5",
    "Cache-Control": "no-cache",
    Connection: "keep-alive",
    "Content-Type": `multipart/form-data; boundary=${boundary}`,
    Origin: "https://github.com",
    Pragma: "no-cache",
    Referer: "https://github.com/",
    "Sec-Fetch-Dest": "empty",
    "Sec-Fetch-Mode": "cors",
    "Sec-Fetch-Site": "cross-site",
    "Sec-GPC": "1",
    "User-Agent":
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36",
    "sec-ch-ua": '"Chromium";v="142", "Brave";v="142", "Not_A Brand";v="99"',
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": '"macOS"',
    cookie: curlCookieFlag,
  };

  await fetch(uploadUrl, {
    method: "POST",
    headers,
    body: bodyBuffer,
  });

  // const outPath = path.join(__dirname, "response_upload2.json");
  // const text = await res.text();
  // try {
  //   fs.writeFileSync(outPath, JSON.stringify(JSON.parse(text), null, 2));
  // } catch {
  //   fs.writeFileSync(outPath, text);
  // }
  // console.log("petition2 finished with status:", res.status);
  // console.log("Response written to", outPath);

  // console.log(petition1Response.asset.href);
}

async function petition3(petition1Response: Petition1Response) {
  const randomString = Array.from(
    { length: 16 },
    () => Math.random().toString(36)[2],
  ).join("");

  const boundary = `----WebKitFormBoundary${randomString}`;
  const body =
    `------WebKitFormBoundary${randomString}\r\n` +
    `Content-Disposition: form-data; name="authenticity_token"\r\n\r\n` +
    `${petition1Response.asset_upload_authenticity_token}` +
    `------WebKitFormBoundary${randomString}--\r\n`;

  const headers = {
    accept: "application/json",
    "accept-language": "en-GB,en;q=0.5",
    "cache-control": "no-cache",
    "content-type": `multipart/form-data; boundary=${boundary}`,
    origin: "https://github.com",
    pragma: "no-cache",
    priority: "u=1, i",
    // referer: "https://github.com/mapfre-tech/arch-mar2-mgmt/issues/1166",
    "sec-ch-ua": '"Chromium";v="142", "Brave";v="142", "Not_A Brand";v="99"',
    "sec-ch-ua-mobile": "?0",
    "sec-ch-ua-platform": '"macOS"',
    "sec-fetch-dest": "empty",
    "sec-fetch-mode": "cors",
    "sec-fetch-site": "same-origin",
    "sec-gpc": "1",
    "user-agent":
      "Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/142.0.0.0 Safari/537.36",
    // "x-fetch-nonce": "v2:c4b80a62-9cfe-2991-bb2c-aaf41d31d659",
    // "x-github-client-version": "6f0a50c83824a7b7b3ed4ac8a758c063075591b0",
    "x-requested-with": "XMLHttpRequest",
    cookie: curlCookieFlag,
  };

  const response = await fetch(
    `https://github.com${petition1Response.asset_upload_url}`,
    {
      method: "PUT",
      headers,
      body,
    },
  );
  const json = await response.json();
  console.log(json.href);
  return json;
}

petition1()
  .catch((error) => {
    console.error("Error during petition1:", error);
  })
  .then((petition1Response) => {
    if (petition1Response) {
      petition2(petition1Response, clipboardImageName)
        .then(() => {
          petition3(petition1Response);
        })
        .catch((error) => {
          console.error("Error during petition2:", error);
        });
    }
  });

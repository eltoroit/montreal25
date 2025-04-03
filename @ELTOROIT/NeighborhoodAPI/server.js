import { Application, Router } from "@oak/oak";
import data from "./data.json" with { type: "json" };

class ZipCodeService {
	// Function to select random zip code data
	getRandomZipCodeData() {
		const zipCodes = Object.keys(data);
		const randomZip = zipCodes[Math.floor(Math.random() * zipCodes.length)];
		return data[randomZip];
	}

	// Function to get data for a specific zip code
	getZipCodeData(zipcode) {
		// If zip code exists, return its data
		if (data[zipcode]) {
			return data[zipcode];
		}

		// If zip code doesn't exist, return random data
		return this.getRandomZipCodeData();
	}
}

class ZipCodeServer {
	constructor() {
		this.zipCodeService = new ZipCodeService();
		this.app = new Application();
		this.router = new Router();
	}

	handleZipCodeRequest(context) {
		const { zipcode } = context.params;

		try {
			const zipData = this.zipCodeService.getZipCodeData(zipcode);
			context.response.body = zipData;
		} catch (error) {
			context.response.status = 500;
			context.response.body = "Error: " + error.message;
		}
	}

	handleRootRequest(context) {
		context.response.body = `
      <!DOCTYPE html>
      <html>
        <head><title>ZipCode Location Simulator</title><head>
        <body>
          <h1>ZipCode Location Simulator</h1>
          <p>
            <a href="/zip/02115">/zip/02115</a>
          </p>
        </body>
      </html>
          `;
	}

	// Method to set up routes and start the server
	setupRoutes() {
		this.router.get("/", (context) => this.handleRootRequest(context));
		this.router.get("/zip/:zipcode", (context) => this.handleZipCodeRequest(context));
		this.app.use(this.router.routes());
		this.app.use(this.router.allowedMethods());
	}

	// Start the server
	start() {
		const port = parseInt(Deno.env.get("PORT") || "3000");
		this.setupRoutes();
		this.app.listen({ port });
		console.log(`Server running on port ${port}: http://localhost:${port}`);
	}
}

// Main entry point
const zipCodeServer = new ZipCodeServer();
zipCodeServer.start();

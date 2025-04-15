import { Application, Router, send } from "@oak/oak";
import data from "./resources/data.json" with { type: "json" };
import spec from "./resources/openAPI.json" with { type: "json" };

class ZipCodeService {
	// Function to select random zip code data
	getRandomZipCodeData() {
		const zipCodes = Object.keys(data);
		const randomZip = zipCodes[Math.floor(Math.random() * zipCodes.length)];
		return data[randomZip];
	}

	// Function to get data for a specific zip code
	getZipCodeData(zipcode) {
		// Validate zip code format
		if (!zipcode || !/^\d{5}$/.test(zipcode)) {
			throw new Error("Invalid ZIP code format. Expected 5-digit number.");
		}

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

	handleRequestZipCode(context) {
		const { zipcode } = context.params;

		try {
			context.response.body = this.zipCodeService.getZipCodeData(zipcode);
		} catch (error) {
			context.response.status = 400;
			context.response.body = { error: error.message };
		}
	}

	async handleRequestRoot(context) {
		await send(context, "resources/home.html", { root: Deno.cwd() });
	}

	async handleRequestELIZA(context) {
		await send(context, "resources/ELIZA.html", { root: Deno.cwd() });
	}

	handleRequestOpenAPISpec(context) {
		context.response.headers.set("Content-Type", "application/json");
		context.response.body = spec;
	}

	async staticFiles(ctx, next) {
		const pathname = ctx.request.url.pathname;
		if (pathname.startsWith("/resources/")) {
			try {
				await send(ctx, pathname, { root: Deno.cwd() });
				return; // Stop processing if file is sent
			} catch (e) {
				console.error("Error serving static file:", e);
				// Continue to next middleware if file not found
			}
		}
		await next();
	}

	setupRoutes() {
		// First apply static file middleware with proper binding, then set up specific routes
		this.router.get("/ELIZA", (context) => this.handleRequestELIZA(context));
		this.router.get("/zip/:zipcode", (context) => this.handleRequestZipCode(context));
		this.router.get("/service.json", (context) => this.handleRequestOpenAPISpec(context));
		this.router.get("/", (context) => this.handleRequestRoot(context));

		this.app.use(this.staticFiles.bind(this));
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

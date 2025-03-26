import { parse, stringify } from "jsr:@libs/xml";

export default class KeyboardReplacements {
	static async readFile() {
		// Read XML file
		const filePath = "./replacements.plist";
		const xmlText = await Deno.readTextFile(filePath);
		let jsonData = parse(xmlText);
		let list = jsonData.plist.array.dict;
		list.forEach((item) => {
			const strings = item.string;
			delete item.key;
			delete item.string;
			let short = strings[0],
				long = strings[1];
			if (short.length > long.length) {
				short = strings[1];
				long = strings[0];
			}
			item.short = short;
			item.long = long;
		});
		list.sort((a, b) => (a.short < b.short ? -1 : 1));
		return jsonData;
	}

	static async writeFile(jsonData) {
		const replacer = "REPLACE_ME";
		// Make temp XML
		let list = [...jsonData.plist.array.dict];
		jsonData.plist.array = replacer;
		let xmlTxt = stringify(jsonData);

		// Fix to the expected format
		list = list
			.map((item) => {
				return `<dict><key>phrase</key><string>${item.long}</string><key>shortcut</key><string>${item.short}</string></dict>`;
			})
			.join("");
		xmlTxt = xmlTxt.replace("REPLACE_ME", list);
		const filePath = "./replacements_out.plist";
		await Deno.writeTextFile(filePath, xmlTxt);
	}
}

const jsonData = await KeyboardReplacements.readFile();
jsonData.plist.array.dict.map((item) => {
	console.log(`${item.short}: ${item.long}\n`);
});
await KeyboardReplacements.writeFile(jsonData);
console.log("DONE");

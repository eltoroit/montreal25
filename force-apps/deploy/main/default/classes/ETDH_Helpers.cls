public inherited sharing class ETDH_Helpers {
	public static void debugStringInChunks(String longString, Integer chunkSize) {
		// Default to 50 if chunkSize is not provided or invalid
		if (chunkSize == null || chunkSize <= 0) {
			chunkSize = 50;
		}

		// Handle null or empty strings
		if (String.isBlank(longString)) {
			System.debug('Input string is empty or null');
			return;
		}

		Integer stringLength = longString.length();
		Double totalChunks = Math.ceil(stringLength / (Double) chunkSize);

		System.debug('Total string length: ' + stringLength);
		System.debug('Splitting into ' + totalChunks + ' chunks of ' + chunkSize + ' characters');

		for (Integer i = 0; i < stringLength; i += chunkSize) {
			// Calculate the end index, making sure not to exceed string length
			Integer endIndex = Math.min(i + chunkSize, stringLength);

			// Extract the chunk
			String chunk = longString.substring(i, endIndex);

			// Debug the chunk with its position information
			System.debug(
				'Chunk ' +
					padNumber((i / chunkSize + 1), 3) +
					' of ' +
					padNumber((totalChunks), 3) +
					' (chars ' +
					padNumber((i + 1), 5) +
					'-' +
					padNumber(endIndex, 5) +
					'): ' +
					chunk
			);
			// System.debug(chunk);
		}
	}

	public static String extractHtml(String input) {
		// Debug input
		System.debug('Before format');
		ETDH_Helpers.debugStringInChunks(input, 100);

		// Process
		String output = input; // .replaceAll('\n', '');
		Integer startIndex = output.indexOf('<');
		Integer endIndex = output.lastIndexOf('>');

		if (startIndex == -1 || endIndex == -1 || startIndex >= endIndex) {
			System.debug('Not an HTML, returning original input');
			return input;
		} else {
			// Process HTML
			output = output.substring(startIndex, endIndex + 1);
			// Clean it twice just in case :-)
			output = cleanHtml(output);
			output = cleanHtml(output);

			// Debug output
			System.debug('Before format');
			ETDH_Helpers.debugStringInChunks(output, 100);

			return output;
		}
	}

	private static String cleanHtml(String htmlContent) {
		String cleanedHtml = htmlContent;
		// Step 1: Replace multiple spaces with a single space
		cleanedHtml = cleanedHtml.replaceAll(' {2,}', ' ');

		// Step 2: Replace consecutive newlines with a single newline
		cleanedHtml = cleanedHtml.replaceAll('\\n{2,}', '\n');

		// Step 3: Replace spaces around newlines with just newlines
		cleanedHtml = cleanedHtml.replaceAll(' \\n ', '\n').replaceAll(' \\n', '\n').replaceAll('\\n ', '\n');

		// Step 4: Replace '>\n' with '>'
		cleanedHtml = cleanedHtml.replaceAll('>\\n', '>');

		// Step 5: Replace '\n<' with '<'
		cleanedHtml = cleanedHtml.replaceAll('\\n<', '<');

		// Step 6: Replace '> <' with '><'
		cleanedHtml = cleanedHtml.replaceAll('> <', '><');

		// Step 7: Handle tabs if present in the HTML
		cleanedHtml = cleanedHtml.replaceAll('\\t+', ' ');

		// Final cleanup pass to catch any patterns that might have been created
		cleanedHtml = cleanedHtml.replaceAll(' {2,}', ' ').replaceAll('>\\n', '>').replaceAll('\\n<', '<').replaceAll('> <', '><');

		return cleanedHtml;
	}

	public static String padNumber(Decimal value, Integer length) {
		return padNumber(Integer.valueOf(value), length);
	}

	public static String padNumber(Integer value, Integer length) {
		return String.valueOf(value).leftPad(length, '0');
	}
}

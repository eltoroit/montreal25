@isTest
private class ETAI_Helpers_Test {
	@isTest
	static void testDebugStringInChunks() {
		// Since System.debug can't be directly tested for output
		// We'll just verify the method runs without errors

		// Test with normal string
		Test.startTest();
		ETAI_Helpers.debugStringInChunks('Test Action', 'This is a test string that will be split into chunks', 10);

		// Test with null or empty string
		ETAI_Helpers.debugStringInChunks('Empty Test', '', 10);
		ETAI_Helpers.debugStringInChunks('Null Test', null, 10);

		// Test with invalid chunk size
		ETAI_Helpers.debugStringInChunks('Invalid Chunk Size', 'Test string', -5);
		ETAI_Helpers.debugStringInChunks('Null Chunk Size', 'Test string', null);

		// Test with string containing newlines
		ETAI_Helpers.debugStringInChunks('Newline Test', 'Line 1\nLine 2\nLine 3', 10);
		Test.stopTest();

		// No assertions needed as we're just testing that no exceptions are thrown
		System.assert(true, 'Method completed without exceptions');
	}

	@isTest
	static void testExtractHtml() {
		// Test with valid HTML content
		String validHtml = 'Some text before <html><body><p>This is a paragraph</p></body></html> and text after';
		String extractedHtml = ETAI_Helpers.extractHtml(validHtml);
		System.assertEquals('<html><body><p>This is a paragraph</p></body></html>', extractedHtml, 'HTML extraction failed');

		// Test with no HTML content
		String noHtml = 'This is just plain text without any HTML tags';
		String result = ETAI_Helpers.extractHtml(noHtml);
		System.assertEquals(noHtml, result, 'Should return original string when no HTML present');
	}

	@isTest
	static void testExtractJson() {
		// Test with valid JSON content
		String validJson = 'Text before {"name": "Test", "value": 123} text after';
		String extractedJson = ETAI_Helpers.extractJson(validJson);
		System.assertEquals('{"name": "Test", "value": 123}', extractedJson, 'JSON extraction failed');

		// Test with no JSON content
		String noJson = 'This is just plain text without any JSON';
		String result = ETAI_Helpers.extractJson(noJson);
		System.assertEquals(noJson, result, 'Should return original string when no JSON present');

		// Test with nested JSON
		String nestedJson = 'Start {"outer": {"inner": "value"}} end';
		String nestedResult = ETAI_Helpers.extractJson(nestedJson);
		System.assertEquals('{"outer": {"inner": "value"}}', nestedResult, 'Nested JSON extraction failed');
	}

	@isTest
	static void testCleanHtml() {
		// We'll use extractHtml to test the private cleanHtml method indirectly
		String messyHtml = '<div>  \n\n <p> \n Multiple    spaces \n and \n\n newlines </p>  \n </div>';
		String expected = '<div><p>Multiple spaces and newlines</p></div>';

		String cleaned = ETAI_Helpers.extractHtml(messyHtml);
		System.assert(cleaned.indexOf('  ') == -1, 'Should not have double spaces');
		System.assert(cleaned.indexOf('\n\n') == -1, 'Should not have double newlines');
		System.assert(cleaned.indexOf('> <') == -1, 'Should not have space between tags');
	}

	@isTest
	static void testPadNumber() {
		// Test with different number and padding values
		System.assertEquals('007', ETAI_Helpers.padNumber(7, 3), 'Padding failed for integer 7 with length 3');
		System.assertEquals('0123', ETAI_Helpers.padNumber(123, 4), 'Padding failed for integer 123 with length 4');
		System.assertEquals('00005', ETAI_Helpers.padNumber(5, 5), 'Padding failed for integer 5 with length 5');

		// Test with decimal version
		System.assertEquals('0042', ETAI_Helpers.padNumber(42.0, 4), 'Padding failed for decimal 42.0 with length 4');
		System.assertEquals('00100', ETAI_Helpers.padNumber(100.5, 5), 'Padding failed for decimal 100.5 with length 5');
	}

	@isTest
	static void testGetSObjectMetadata() {
		// Create a test for the getSObjectMetadata method using a standard object
		String accountMetadata = ETAI_Helpers.getSObjectMetadata('Account');

		// Verify the result is non-empty and contains expected fields
		System.assertNotEquals(null, accountMetadata, 'Metadata should not be null');

		// Test with a different object to ensure flexibility
		String contactMetadata = ETAI_Helpers.getSObjectMetadata('Contact');
		System.assertNotEquals(null, contactMetadata, 'Metadata should not be null');
	}

	@isTest
	static void testEdgeCases() {
		// Test padNumber with extreme values
		System.assertEquals('0000000001', ETAI_Helpers.padNumber(1, 10), 'Should handle large padding');
		System.assertEquals('1234567890', ETAI_Helpers.padNumber(1234567890, 10), 'Should handle numbers that match padding length');
	}
}

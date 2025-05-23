class Eliza {
	constructor() {
		this.initialMessages = ["Hello. How are you feeling today?", "Please tell me what's been bothering you.", "How can I help you today?"];

		this.goodbyes = ["goodbye", "bye", "quit", "exit", "leave"];

		// Key transformation rules based on ELIZA's original implementation
		this.reflections = {
			am: "are",
			was: "were",
			i: "you",
			"i'd": "you would",
			"i've": "you have",
			"i'll": "you will",
			my: "your",
			are: "am",
			"you've": "I have",
			"you'll": "I will",
			your: "my",
			yours: "mine",
			you: "I",
			me: "you"
		};

		this.patterns = [
			// Each pattern has:
			// - regex: the pattern to match
			// - responses: array of possible responses
			// - needsReflection: boolean indicating if pronouns need to be reflected
			// - captureGroup: the regex group to capture for reflection (if needed)

			// I am / I'm pattern
			{
				regex: /i(?:'m| am) (.*)/i,
				responses: ["Why are you %s?", "How long have you been %s?", "Do you enjoy being %s?", "What does being %s mean to you?"],
				needsReflection: true,
				captureGroup: 1
			},

			// I want pattern
			{
				regex: /i want (.*)/i,
				responses: [
					"Why do you want %s?",
					"What would it mean if you got %s?",
					"Suppose you got %s, then what would you do?",
					"What is stopping you from getting %s?"
				],
				needsReflection: true,
				captureGroup: 1
			},

			// I feel pattern
			{
				regex: /i feel (.*)/i,
				responses: ["Tell me more about feeling %s.", "How long have you felt %s?", "Do you often feel %s?", "What causes you to feel %s?"],
				needsReflection: true,
				captureGroup: 1
			},

			// I think pattern
			{
				regex: /i think (.*)/i,
				responses: ["Why do you think %s?", "Do you really think %s?", "What makes you think %s?", "Have you always thought %s?"],
				needsReflection: true,
				captureGroup: 1
			},

			// I need pattern
			{
				regex: /i need (.*)/i,
				responses: [
					"Why do you need %s?",
					"Would it really help you to get %s?",
					"Are you sure you need %s?",
					"What would happen if you didn't get %s?"
				],
				needsReflection: true,
				captureGroup: 1
			},

			// I can't pattern
			{
				regex: /i can'?t (.*)/i,
				responses: ["Why can't you %s?", "Have you tried to %s?", "Perhaps you could %s now?", "What would happen if you could %s?"],
				needsReflection: true,
				captureGroup: 1
			},

			// I wish pattern
			{
				regex: /i wish (.*)/i,
				responses: [
					"Why do you wish %s?",
					"What would it mean if %s?",
					"Suppose %s came true, what then?",
					"What steps could you take to make %s happen?"
				],
				needsReflection: true,
				captureGroup: 1
			},

			// Are you pattern
			{
				regex: /are you (.*)\??/i,
				responses: [
					"Why does it matter whether I am %s?",
					"Would you prefer if I were %s?",
					"Perhaps I am %s in your imagination.",
					"What if I were %s?"
				],
				needsReflection: false,
				captureGroup: 1
			},

			// You are pattern
			{
				regex: /you are (.*)/i,
				responses: [
					"Why do you think I am %s?",
					"Does it please you to believe I am %s?",
					"Perhaps you would like to be %s?",
					"Is this how you see me?"
				],
				needsReflection: false,
				captureGroup: 1
			},

			// Why pattern
			{
				regex: /why (.*)\??/i,
				responses: [
					"Why do you think %s?",
					"What makes you wonder why %s?",
					"What answers have you considered for why %s?",
					"What do you think are the reasons?"
				],
				needsReflection: true,
				captureGroup: 1
			},

			// Emotion patterns
			{
				regex: /\b(?:sad|depressed|unhappy|miserable)\b/i,
				responses: [
					"I'm sorry to hear that you're feeling that way.",
					"What is making you feel sad?",
					"Can you explain what's causing these feelings?",
					"How long have you been feeling this way?"
				]
			},

			{
				regex: /\b(?:happy|excited|glad|delighted)\b/i,
				responses: [
					"That's wonderful! What is making you feel happy?",
					"I'm glad to hear you're feeling good. Why do you think that is?",
					"What has been bringing you joy lately?",
					"Can you share more about what's making you happy?"
				]
			},

			{
				regex: /\b(?:worried|anxious|nervous|scared)\b/i,
				responses: [
					"What are you worried about?",
					"What's causing you to feel anxious?",
					"Is there something specific that's making you nervous?",
					"Have you felt this anxiety before?"
				]
			},

			{
				regex: /\b(?:angry|mad|furious|upset)\b/i,
				responses: [
					"What is making you angry?",
					"Why are you feeling upset?",
					"What happened to make you feel this way?",
					"How do you typically handle your anger?"
				]
			},

			// Topic patterns
			{
				regex: /\b(?:mother|mom|mum)\b/i,
				responses: [
					"Tell me more about your mother.",
					"How is your relationship with your mother?",
					"How do you feel about your mother?",
					"How does your mother influence your life?"
				]
			},

			{
				regex: /\b(?:father|dad|daddy|pop)\b/i,
				responses: [
					"Tell me more about your father.",
					"How is your relationship with your father?",
					"How do you feel about your father?",
					"What role does your father play in your life?"
				]
			},

			{
				regex: /\b(?:friend|friends)\b/i,
				responses: [
					"Tell me more about your friends.",
					"Are your friends important to you?",
					"How do your friends make you feel?",
					"What do you value in your friendships?"
				]
			},

			{
				regex: /\b(?:computer|ai|chatbot|eliza|program)\b/i,
				responses: [
					"Are you uncomfortable talking to a computer?",
					"Do computers worry you?",
					"Why do you mention computers?",
					"How do you feel about talking to me, a computer program?"
				]
			},

			// Simple patterns
			{
				regex: /\byes\b/i,
				responses: ["You seem quite positive.", "Are you sure?", "I see. Can you elaborate on that?", "You sound confident about that."]
			},

			{
				regex: /\bno\b/i,
				responses: [
					"Why not?",
					"Are you always so negative?",
					"Can you explain why you feel that way?",
					"Is there a reason for your disagreement?"
				]
			},

			{
				regex: /\b(?:hello|hi|hey)\b/i,
				responses: [
					"Hello. How are you feeling today?",
					"Hi there. What's on your mind?",
					"Hello. How can I help you today?",
					"Greetings. What would you like to talk about?"
				]
			},

			{
				regex: /\b(?:thank you|thanks)\b/i,
				responses: [
					"You're welcome!",
					"I'm glad I could help.",
					"The pleasure is mine.",
					"Don't mention it. Is there anything else on your mind?"
				]
			},

			// Relationship, work, health patterns
			{
				regex: /\b(?:relationship|marriage|partner|spouse|boyfriend|girlfriend)\b/i,
				responses: [
					"Tell me more about your relationships.",
					"How do your relationships affect you?",
					"What patterns do you see in your relationships?",
					"How do you feel about the people closest to you?"
				]
			},

			{
				regex: /\b(?:job|work|career|profession)\b/i,
				responses: [
					"Tell me about your job.",
					"How does your work make you feel?",
					"What aspects of your job are most challenging?",
					"Do you find fulfillment in your work?"
				]
			},

			{
				regex: /\b(?:health|illness|sick|disease)\b/i,
				responses: [
					"How is your health affecting you?",
					"Are you concerned about your health?",
					"What are you doing to maintain your health?",
					"How long have you been concerned about your health?"
				]
			}
		];

		this.fallbackResponses = [
			"Can you elaborate on that?",
			"How does that make you feel?",
			"Why do you say that?",
			"Please tell me more.",
			"I see. Please continue.",
			"Interesting. Can you tell me more?",
			"And how do you feel about that?",
			"How long have you felt this way?",
			"Why do you think that is?",
			"Can you share more about that experience?"
		];
	}

	getInitialMessage() {
		return this.initialMessages[Math.floor(Math.random() * this.initialMessages.length)];
	}

	isGoodbye(input) {
		return this.goodbyes.some((goodbye) => input.toLowerCase().includes(goodbye));
	}

	// Helper function to reflect pronouns
	reflectWords(text) {
		return text
			.toLowerCase()
			.split(/\s+/)
			.map((word) => this.reflections[word] || word)
			.join(" ");
	}

	generateResponse(input) {
		// Check for goodbyes
		if (this.isGoodbye(input)) {
			return "It was nice talking to you. Take care!";
		}

		// Process input with patterns
		for (const pattern of this.patterns) {
			const match = input.match(pattern.regex);

			if (match) {
				// Select a random response template
				const responseTemplate = pattern.responses[Math.floor(Math.random() * pattern.responses.length)];

				// If we need to substitute captured text
				if (pattern.captureGroup !== undefined && match[pattern.captureGroup]) {
					let captured = match[pattern.captureGroup].trim();

					// Apply reflection if needed
					if (pattern.needsReflection) {
						captured = this.reflectWords(captured);
					}

					// Replace the placeholder with the processed text
					return responseTemplate.replace("%s", captured);
				}

				return responseTemplate;
			}
		}

		// If no pattern matches, return a fallback response
		return this.fallbackResponses[Math.floor(Math.random() * this.fallbackResponses.length)];
	}
}

// Initialize the application
document.addEventListener("DOMContentLoaded", () => {
	const setChat = () => {
		const processUserInput = () => {
			const message = userInput.value.trim();
			if (message === "") return;

			// Add user message to chat
			addMessage(message, "user");

			// Clear input field
			userInput.value = "";

			// Get ELIZA's response after a short delay (simulates thinking)
			setTimeout(
				() => {
					const response = eliza.generateResponse(message);
					addMessage(response, "eliza");

					// Auto scroll to bottom
					chatContainer.scrollTop = chatContainer.scrollHeight;
				},
				500 + Math.random() * 500
			); // Random delay between 500-1000ms
		};

		const addMessage = (text, sender) => {
			const messageElement = document.createElement("div");
			messageElement.classList.add("message");
			messageElement.classList.add(`${sender}-message`);
			messageElement.textContent = text;
			chatContainer.appendChild(messageElement);

			// Auto scroll to bottom
			chatContainer.scrollTop = chatContainer.scrollHeight;
		};

		const chatContainer = document.getElementById("chat-container");
		const userInput = document.getElementById("user-input");
		const sendButton = document.getElementById("send-button");

		const eliza = new Eliza();

		// Display initial message
		addMessage(eliza.getInitialMessage(), "eliza");

		// Event listeners
		sendButton.addEventListener("click", processUserInput);
		userInput.addEventListener("keypress", (e) => {
			if (e.key === "Enter") {
				processUserInput();
			}
		});
	};

	const setUI = () => {
		document.querySelectorAll(".collapsible").forEach((btn) => {
			btn.addEventListener("click", function () {
				this.classList.toggle("active");
				const content = this.nextElementSibling;
				if (content.style.display === "block") {
					content.style.display = "none";
				} else {
					content.style.display = "block";
				}
			});
		});
	};

	setChat();
	setUI();
});

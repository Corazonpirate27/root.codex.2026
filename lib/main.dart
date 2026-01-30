import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(const RootAcademyApp());
}

class RootAcademyApp extends StatelessWidget {
  const RootAcademyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'ROOT Academy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF050505),
        primaryColor: const Color(0xFF00ff41),
        textTheme: GoogleFonts.spaceGroteskTextTheme(
          Theme.of(context).textTheme.apply(
            bodyColor: const Color(0xFFE5E5E5),
            displayColor: Colors.white,
          ),
        ),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF00ff41),
          surface: Color(0xFF0A0A0A),
        ),
        useMaterial3: true,
      ),
      home: const MainNavigationScreen(),
    );
  }
}

class MainNavigationScreen extends StatefulWidget {
  const MainNavigationScreen({super.key});

  @override
  State<MainNavigationScreen> createState() => _MainNavigationScreenState();
}

class _MainNavigationScreenState extends State<MainNavigationScreen> {
  int _selectedIndex = 0;

  final List<Widget> _screens = [
    const CodexScreen(),  // Default Home
    const ArcadeScreen(), // Tools
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_selectedIndex],
      bottomNavigationBar: Container(
        decoration: const BoxDecoration(
          border: Border(top: BorderSide(color: Colors.white10)),
        ),
        child: NavigationBar(
          backgroundColor: Colors.black.withOpacity(0.9),
          indicatorColor: const Color(0xFF00ff41).withOpacity(0.2),
          selectedIndex: _selectedIndex,
          onDestinationSelected: (index) => setState(() => _selectedIndex = index),
          destinations: const [
            NavigationDestination(
              icon: Icon(Icons.menu_book_outlined),
              selectedIcon: Icon(Icons.menu_book, color: Color(0xFF00ff41)),
              label: 'The Codex',
            ),
            NavigationDestination(
              icon: Icon(Icons.gamepad_outlined),
              selectedIcon: Icon(Icons.gamepad, color: Color(0xFF00ff41)),
              label: 'Arcade',
            ),
          ],
        ),
      ),
    );
  }
}

// --- 1. CODEX SCREEN (TECH DICTIONARY) ---

class CodexScreen extends StatefulWidget {
  const CodexScreen({super.key});

  @override
  State<CodexScreen> createState() => _CodexScreenState();
}

class _CodexScreenState extends State<CodexScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, String>> _filteredTerms = [];
  String _selectedCategory = "All";

  final List<String> _categories = ["All", "AI", "Cyber", "Data", "DevOps", "Cloud", "Web3", "Mobile", "IoT", "Code", "CS"];

  @override
  void initState() {
    super.initState();
    _filteredTerms = _dictionaryData;
    _dictionaryData.sort((a, b) => a['term']!.compareTo(b['term']!));
  }

  void _filterData() {
    final query = _searchController.text.toLowerCase();
    setState(() {
      _filteredTerms = _dictionaryData.where((item) {
        final matchesQuery = item['term']!.toLowerCase().contains(query) ||
            item['def']!.toLowerCase().contains(query);
        final matchesCategory = _selectedCategory == "All" || item['cat'] == _selectedCategory;
        return matchesQuery && matchesCategory;
      }).toList();
    });
  }

  void _showDefinition(BuildContext context, Map<String, String> term) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.black,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (context) => DraggableScrollableSheet(
        initialChildSize: 0.4,
        minChildSize: 0.3,
        maxChildSize: 0.8,
        expand: false,
        builder: (_, controller) => Container(
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: const Color(0xFF0A0A0A),
            border: Border(top: BorderSide(color: const Color(0xFF00ff41).withOpacity(0.3))),
            borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: ListView(
            controller: controller,
            children: [
              Center(child: Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.white24, borderRadius: BorderRadius.circular(2)))),
              const SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Flexible(
                    child: Text(term['term']!, style: GoogleFonts.spaceGrotesk(fontSize: 28, fontWeight: FontWeight.bold, color: Colors.white)),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    decoration: BoxDecoration(
                        border: Border.all(color: _getCategoryColor(term['cat']!).withOpacity(0.5)),
                        borderRadius: BorderRadius.circular(20)
                    ),
                    child: Text(term['cat']!, style: TextStyle(fontSize: 10, color: _getCategoryColor(term['cat']!), fontWeight: FontWeight.bold, letterSpacing: 1)),
                  )
                ],
              ),
              const SizedBox(height: 20),
              Text(term['def']!, style: const TextStyle(fontSize: 16, color: Colors.white70, height: 1.6)),
              const SizedBox(height: 40),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF00ff41),
                    foregroundColor: Colors.black,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text("CLOSE PROTOCOL", style: TextStyle(fontWeight: FontWeight.bold)),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Color _getCategoryColor(String cat) {
    switch (cat) {
      case 'AI': return Colors.purpleAccent;
      case 'Cyber': return Colors.redAccent;
      case 'Data': return Colors.blueAccent;
      case 'DevOps': return Colors.orangeAccent;
      case 'Web3': return Colors.yellowAccent;
      case 'Cloud': return Colors.cyanAccent;
      case 'Mobile': return Colors.greenAccent;
      case 'IoT': return Colors.brown;
      case 'Code': return Colors.pinkAccent;
      case 'CS': return Colors.tealAccent;
      default: return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            const Icon(Icons.terminal, color: Color(0xFF00ff41)),
            const SizedBox(width: 10),
            Text('ROOT.CODEX', style: GoogleFonts.spaceGrotesk(fontSize: 20, fontWeight: FontWeight.bold, letterSpacing: 2)),
          ],
        ),
        centerTitle: false,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(110),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  controller: _searchController,
                  onChanged: (_) => _filterData(),
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    hintText: "Search 400+ definitions...",
                    hintStyle: const TextStyle(color: Colors.white24),
                    prefixIcon: const Icon(Icons.search, color: Color(0xFF00ff41)),
                    filled: true,
                    fillColor: Colors.white.withOpacity(0.05),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
                    focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: const BorderSide(color: Color(0xFF00ff41))),
                  ),
                ),
              ),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: _categories.map((cat) {
                    final isSelected = _selectedCategory == cat;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(cat),
                        selected: isSelected,
                        onSelected: (bool selected) {
                          setState(() {
                            _selectedCategory = cat;
                            _filterData();
                          });
                        },
                        backgroundColor: Colors.white.withOpacity(0.05),
                        selectedColor: _getCategoryColor(cat).withOpacity(0.2),
                        checkmarkColor: _getCategoryColor(cat),
                        labelStyle: TextStyle(
                            color: isSelected ? _getCategoryColor(cat) : Colors.white54,
                            fontWeight: isSelected ? FontWeight.bold : FontWeight.normal
                        ),
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide(
                                color: isSelected ? _getCategoryColor(cat) : Colors.transparent
                            )
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ),
      ),
      body: _filteredTerms.isEmpty
          ? Center(child: Text("NO DATA FOUND", style: GoogleFonts.spaceMono(color: Colors.white24)))
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: _filteredTerms.length,
        itemBuilder: (context, index) {
          final term = _filteredTerms[index];
          return Container(
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.02),
              border: Border.all(color: Colors.white.withOpacity(0.05)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ListTile(
              title: Text(term['term']!, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold)),
              subtitle: Text(term['def']!, maxLines: 1, overflow: TextOverflow.ellipsis, style: const TextStyle(color: Colors.white38, fontSize: 12)),
              trailing: Text(term['cat']!, style: TextStyle(color: _getCategoryColor(term['cat']!), fontSize: 10, fontWeight: FontWeight.bold)),
              onTap: () => _showDefinition(context, term),
            ),
          );
        },
      ),
    );
  }
}

// --- 2. ARCADE SCREEN ---

class ArcadeScreen extends StatefulWidget {
  const ArcadeScreen({super.key});

  @override
  State<ArcadeScreen> createState() => _ArcadeScreenState();
}

class _ArcadeScreenState extends State<ArcadeScreen> {
  String _excuse = "System functioning within normal parameters.";
  final List<String> excuses = [
    "It works on my machine.", "It's not a bug, it's a feature.", "I haven't touched that module in weeks.", "It must be a caching issue.",
    "The third-party API is down.", "DNS propagation takes 24 hours.", "The user must be doing something wrong.", "I thought you signed off on that.",
    "That was just a temporary fix.", "The wifi signal is weak here."
  ];

  void _generateExcuse() {
    setState(() { _excuse = excuses[DateTime.now().millisecond % excuses.length]; });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Student Arcade')),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          children: [
            Container(
              width: double.infinity, padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(color: Colors.red.withOpacity(0.05), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.red.withOpacity(0.2))),
              child: Column(children: [
                const Icon(Icons.bug_report, color: Colors.redAccent, size: 40), const SizedBox(height: 16),
                const Text('DEV EXCUSE PROTOCOL', style: TextStyle(color: Colors.redAccent, fontSize: 10, letterSpacing: 2, fontWeight: FontWeight.bold)),
                const SizedBox(height: 16),
                Text('"$_excuse"', textAlign: TextAlign.center, style: GoogleFonts.spaceGrotesk(fontSize: 18, fontStyle: FontStyle.italic)),
                const SizedBox(height: 24),
                ElevatedButton(onPressed: _generateExcuse, style: ElevatedButton.styleFrom(backgroundColor: Colors.red.withOpacity(0.1), foregroundColor: Colors.redAccent, shape: const StadiumBorder(), side: const BorderSide(color: Colors.redAccent)), child: const Text('GENERATE ALIBI'))
              ]),
            ),
          ],
        ),
      ),
    );
  }
}

// --- MASSIVE CODEX DATABASE (2026 EDITION) ---

final List<Map<String, String>> _dictionaryData = [
  // --- ARTIFICIAL INTELLIGENCE ---
  {"term": "Agentic AI", "def": "Autonomous AI systems capable of pursuing complex goals with limited direct supervision, planning actions, and using tools.", "cat": "AI"},
  {"term": "AGI", "def": "Artificial General Intelligence. Hypothetical AI with the ability to understand, learn, and apply knowledge across a wide variety of tasks like a human.", "cat": "AI"},
  {"term": "Alignment", "def": "The field of ensuring AI systems' goals and behaviors align with human values and intent.", "cat": "AI"},
  {"term": "Auto-GPT", "def": "An open-source application that uses GPT-4 to act autonomously, chaining thoughts to achieve a user-defined goal.", "cat": "AI"},
  {"term": "Backpropagation", "def": "The algorithm used to train neural networks by calculating the gradient of the loss function.", "cat": "AI"},
  {"term": "Chain of Thought", "def": "A prompting technique that encourages LLMs to explain their reasoning step-by-step.", "cat": "AI"},
  {"term": "Computer Vision", "def": "A field of AI enabling computers to derive meaningful information from digital images/videos.", "cat": "AI"},
  {"term": "Constitutional AI", "def": "An approach where AI models are trained to follow a set of principles or a 'constitution' to ensure safety.", "cat": "AI"},
  {"term": "Deepfake", "def": "Synthetic media in which a person in an image or video is replaced with someone else's likeness using AI.", "cat": "AI"},
  {"term": "Diffusion Model", "def": "A type of generative model used to generate high-quality images by learning to reverse a gradual noise addition process.", "cat": "AI"},
  {"term": "Embeddings", "def": "Vector representations of text where words with similar meanings have a similar representation.", "cat": "AI"},
  {"term": "Federated Learning", "def": "A machine learning technique that trains an algorithm across multiple decentralized edge devices without exchanging local data samples.", "cat": "AI"},
  {"term": "Fine-Tuning", "def": "Taking a pre-trained model and training it further on a specific dataset to specialize its performance.", "cat": "AI"},
  {"term": "GAN", "def": "Generative Adversarial Network. Two neural networks (generator and discriminator) competing to create realistic data.", "cat": "AI"},
  {"term": "Hallucination", "def": "When an AI model generates incorrect or nonsensical information confidently.", "cat": "AI"},
  {"term": "Hyperparameter", "def": "A configuration that is external to the model and whose value cannot be estimated from data.", "cat": "AI"},
  {"term": "Inference", "def": "The process of using a trained machine learning model to make predictions on live data.", "cat": "AI"},
  {"term": "Knowledge Graph", "def": "A structured representation of facts, consisting of entities, relationships, and semantic information.", "cat": "AI"},
  {"term": "LLM", "def": "Large Language Model. A deep learning model trained on massive datasets to understand and generate human language.", "cat": "AI"},
  {"term": "LoRA", "def": "Low-Rank Adaptation. A technique to fine-tune large models efficiently by freezing weights and training small rank decomposition matrices.", "cat": "AI"},
  {"term": "Model Collapse", "def": "A degenerative process affecting generative AI models trained on AI-generated data, leading to a loss of variance and quality.", "cat": "AI"},
  {"term": "Multimodal", "def": "AI models capable of processing and generating multiple types of media (text, images, audio) simultaneously.", "cat": "AI"},
  {"term": "Neural Network", "def": "A series of algorithms that endeavors to recognize underlying relationships in a set of data.", "cat": "AI"},
  {"term": "NLP", "def": "Natural Language Processing. The interaction between computers and human language.", "cat": "AI"},
  {"term": "Overfitting", "def": "When a model learns the training data too well, including noise, negatively impacting performance on new data.", "cat": "AI"},
  {"term": "Parameter", "def": "A configuration variable that is internal to the model and whose value can be estimated from data.", "cat": "AI"},
  {"term": "Prompt Engineering", "def": "The art of crafting inputs (prompts) to get the best possible output from a generative AI model.", "cat": "AI"},
  {"term": "RAG", "def": "Retrieval-Augmented Generation. Combining an LLM with an external knowledge base to improve accuracy.", "cat": "AI"},
  {"term": "Reinforcement Learning", "def": "Training models to make a sequence of decisions by rewarding desired behaviors and punishing undesired ones.", "cat": "AI"},
  {"term": "RLHF", "def": "Reinforcement Learning from Human Feedback. Fine-tuning models using human feedback to align them with human intent.", "cat": "AI"},
  {"term": "Sentiment Analysis", "def": "Using NLP to determine the emotional tone behind a body of text.", "cat": "AI"},
  {"term": "Supervised Learning", "def": "Training a model on labeled data where the correct output is known.", "cat": "AI"},
  {"term": "Synthetic Data", "def": "Information that's artificially generated rather than produced by real-world events.", "cat": "AI"},
  {"term": "Tokenization", "def": "Breaking down text into smaller units (tokens) for processing by an AI model.", "cat": "AI"},
  {"term": "Transformer", "def": "The deep learning architecture behind modern LLMs, using self-attention mechanisms.", "cat": "AI"},
  {"term": "Turing Test", "def": "A test of a machine's ability to exhibit intelligent behavior equivalent to, or indistinguishable from, that of a human.", "cat": "AI"},
  {"term": "Unsupervised Learning", "def": "Training a model on unlabeled data to find hidden patterns.", "cat": "AI"},
  {"term": "Vector Database", "def": "A database optimized for storing and querying high-dimensional vector embeddings, crucial for RAG.", "cat": "AI"},
  {"term": "Vision Transformer", "def": "ViT. An architecture that applies Transformers directly to sequences of image patches.", "cat": "AI"},
  {"term": "Weights", "def": "The learnable parameters in a neural network that transform input data.", "cat": "AI"},
  {"term": "XAI", "def": "Explainable AI. Methods and techniques in the application of artificial intelligence such that the results of the solution can be understood by humans.", "cat": "AI"},
  {"term": "Zero-Shot Learning", "def": "The ability of a model to perform a task without having explicitly seen an example of it during training.", "cat": "AI"},

  // --- CYBERSECURITY ---
  {"term": "Air Gap", "def": "A security measure where a computer is physically isolated from unsecured networks (internet).", "cat": "Cyber"},
  {"term": "APT", "def": "Advanced Persistent Threat. A prolonged and targeted cyberattack where an intruder gains access and remains undetected.", "cat": "Cyber"},
  {"term": "Blue Team", "def": "Security professionals who defend an organization's information systems against attackers.", "cat": "Cyber"},
  {"term": "Botnet", "def": "A network of private computers infected with malicious software and controlled as a group without the owners' knowledge.", "cat": "Cyber"},
  {"term": "Bug Bounty", "def": "A deal offered by many websites and software developers by which individuals can receive recognition and compensation for reporting bugs.", "cat": "Cyber"},
  {"term": "C2 Server", "def": "Command and Control Server. A computer controlled by an attacker used to send commands to systems compromised by malware.", "cat": "Cyber"},
  {"term": "CIA Triad", "def": "Confidentiality, Integrity, Availability. The three pillars of information security.", "cat": "Cyber"},
  {"term": "Clickjacking", "def": "Tricking a web user into clicking on something different from what the user perceives.", "cat": "Cyber"},
  {"term": "Credential Stuffing", "def": "A cyberattack where stolen account credentials are used to gain unauthorized access to user accounts.", "cat": "Cyber"},
  {"term": "Cross-Site Scripting", "def": "XSS. A vulnerability that enables attackers to inject client-side scripts into web pages viewed by other users.", "cat": "Cyber"},
  {"term": "Cryptography", "def": "The practice and study of techniques for secure communication in the presence of third parties.", "cat": "Cyber"},
  {"term": "Dark Web", "def": "Part of the World Wide Web that is only accessible by means of special software (Tor), allowing anonymity.", "cat": "Cyber"},
  {"term": "DDoS", "def": "Distributed Denial of Service. Overwhelming a target with a flood of internet traffic.", "cat": "Cyber"},
  {"term": "Deep Packet Inspection", "def": "A form of computer network packet filtering that examines the data part of a packet.", "cat": "Cyber"},
  {"term": "Encryption", "def": "Encoding information so only authorized parties can access it.", "cat": "Cyber"},
  {"term": "Exploit", "def": "Code that takes advantage of a software vulnerability or security flaw.", "cat": "Cyber"},
  {"term": "Firewall", "def": "A network security system that monitors and controls incoming and outgoing network traffic.", "cat": "Cyber"},
  {"term": "Honeypot", "def": "A decoy system intended to attract cyberattackers to detect, deflect, or study attempts.", "cat": "Cyber"},
  {"term": "Identity Management", "def": "IAM. The security discipline that enables the right individuals to access the right resources at the right times.", "cat": "Cyber"},
  {"term": "Incident Response", "def": "The approach to handling a security breach or cyberattack.", "cat": "Cyber"},
  {"term": "Insider Threat", "def": "A malicious threat to an organization that comes from people within the organization.", "cat": "Cyber"},
  {"term": "Keylogger", "def": "Spyware that records every keystroke made by a computer user.", "cat": "Cyber"},
  {"term": "Logic Bomb", "def": "Malicious code inserted into a system that executes when specific conditions are met.", "cat": "Cyber"},
  {"term": "Malware", "def": "Software intentionally designed to cause damage to a computer, server, client, or computer network.", "cat": "Cyber"},
  {"term": "Man-in-the-Middle", "def": "MITM. An attack where the attacker secretly relays and possibly alters the communications between two parties.", "cat": "Cyber"},
  {"term": "MFA", "def": "Multi-Factor Authentication. Using two or more pieces of evidence (factors) to verify a user's identity.", "cat": "Cyber"},
  {"term": "OSINT", "def": "Open Source Intelligence. Data collected from publicly available sources to be used in an intelligence context.", "cat": "Cyber"},
  {"term": "Penetration Testing", "def": "Ethical hacking. A simulated cyberattack against your computer system to check for exploitable vulnerabilities.", "cat": "Cyber"},
  {"term": "Phishing", "def": "Sending fraudulent communications that appear to come from a reputable source.", "cat": "Cyber"},
  {"term": "PKI", "def": "Public Key Infrastructure. A set of roles, policies, and procedures needed to create, manage, distribute, use, store, and revoke digital certificates.", "cat": "Cyber"},
  {"term": "Post-Quantum Crypto", "def": "Cryptographic algorithms thought to be secure against an attack by a quantum computer.", "cat": "Cyber"},
  {"term": "Ransomware", "def": "Malware that employs encryption to hold a victim's information at ransom.", "cat": "Cyber"},
  {"term": "Red Team", "def": "A group that plays the role of the enemy or attacker to provide security feedback.", "cat": "Cyber"},
  {"term": "Rootkit", "def": "A collection of computer software designed to enable access to a computer or an area of its software that is not otherwise allowed.", "cat": "Cyber"},
  {"term": "Sandbox", "def": "An isolated environment on a network that mimics end-user operating environments.", "cat": "Cyber"},
  {"term": "Security Token", "def": "A physical device that an authorized user of computer services is given to ease authentication.", "cat": "Cyber"},
  {"term": "SIEM", "def": "Security Information and Event Management. Software that gives a real-time analysis of security alerts generated by network hardware and applications.", "cat": "Cyber"},
  {"term": "Social Engineering", "def": "Manipulating people into performing actions or divulging confidential information.", "cat": "Cyber"},
  {"term": "SOC", "def": "Security Operations Center. A centralized unit that deals with security issues on an organizational and technical level.", "cat": "Cyber"},
  {"term": "Spear Phishing", "def": "An email-spoofing attack that targets a specific organization or individual.", "cat": "Cyber"},
  {"term": "SQL Injection", "def": "A code injection technique used to attack data-driven applications by inserting malicious SQL statements.", "cat": "Cyber"},
  {"term": "Steganography", "def": "The practice of concealing a file, message, image, or video within another file, message, image, or video.", "cat": "Cyber"},
  {"term": "Threat Hunting", "def": "The process of proactively searching for malware or attackers that are lurking in a network.", "cat": "Cyber"},
  {"term": "Trojan Horse", "def": "Malware which misleads users of its true intent.", "cat": "Cyber"},
  {"term": "VPN", "def": "Virtual Private Network. Extends a private network across a public network.", "cat": "Cyber"},
  {"term": "WAF", "def": "Web Application Firewall. Protects web applications by filtering and monitoring HTTP traffic between a web application and the Internet.", "cat": "Cyber"},
  {"term": "White Hat", "def": "An ethical computer hacker who specializes in penetration testing.", "cat": "Cyber"},
  {"term": "Zero Trust", "def": "A security concept centered on the belief that organizations should not automatically trust anything inside or outside its perimeters.", "cat": "Cyber"},
  {"term": "Zero-Day", "def": "A vulnerability that is unknown to those who should be interested in mitigating the vulnerability.", "cat": "Cyber"},
  {"term": "Zombie", "def": "A computer connected to the Internet that has been compromised by a hacker and can be used to perform malicious tasks.", "cat": "Cyber"},

  // --- DATA SCIENCE ---
  {"term": "A/B Testing", "def": "Comparing two versions of a webpage or app against each other to determine which one performs better.", "cat": "Data"},
  {"term": "Accuracy", "def": "The fraction of predictions our model got right.", "cat": "Data"},
  {"term": "Algorithm", "def": "A process or set of rules to be followed in calculations.", "cat": "Data"},
  {"term": "Apache Spark", "def": "An open-source unified analytics engine for large-scale data processing.", "cat": "Data"},
  {"term": "Bayesian Statistics", "def": "A theory in the field of statistics based on the Bayesian interpretation of probability.", "cat": "Data"},
  {"term": "Bias-Variance Tradeoff", "def": "The property of a set of predictive models whereby models with a lower bias in parameter estimation have a higher variance of the parameter estimates.", "cat": "Data"},
  {"term": "Big Data", "def": "Data sets that are too large or complex to be dealt with by traditional data-processing application software.", "cat": "Data"},
  {"term": "Binomial Distribution", "def": "A frequency distribution of the possible number of successful outcomes in a given number of trials.", "cat": "Data"},
  {"term": "Categorical Data", "def": "Variables that contain label values rather than numeric values.", "cat": "Data"},
  {"term": "Classification", "def": "Identifying to which of a set of categories a new observation belongs.", "cat": "Data"},
  {"term": "Clustering", "def": "Grouping a set of objects in such a way that objects in the same group are more similar to each other than to those in other groups.", "cat": "Data"},
  {"term": "Confusion Matrix", "def": "A table that is often used to describe the performance of a classification model.", "cat": "Data"},
  {"term": "Correlation", "def": "A mutual relationship or connection between two or more things.", "cat": "Data"},
  {"term": "Data Cleaning", "def": "The process of detecting and correcting (or removing) corrupt or inaccurate records.", "cat": "Data"},
  {"term": "Data Engineering", "def": "The aspect of data science that focuses on practical applications of data collection and analysis.", "cat": "Data"},
  {"term": "Data Lake", "def": "A system or repository of data stored in its natural/raw format.", "cat": "Data"},
  {"term": "Data Mining", "def": "The process of discovering patterns in large data sets.", "cat": "Data"},
  {"term": "Data Pipeline", "def": "A set of data processing elements connected in series.", "cat": "Data"},
  {"term": "Data Warehouse", "def": "A large store of data accumulated from a wide range of sources within a company.", "cat": "Data"},
  {"term": "Decision Tree", "def": "A flowchart-like structure in which each internal node represents a test on an attribute.", "cat": "Data"},
  {"term": "Dimensionality Reduction", "def": "Reducing the number of random variables under consideration.", "cat": "Data"},
  {"term": "EDA", "def": "Exploratory Data Analysis. Analyzing data sets to summarize their main characteristics.", "cat": "Data"},
  {"term": "ETL", "def": "Extract, Transform, Load. Three database functions that are combined into one tool.", "cat": "Data"},
  {"term": "F1 Score", "def": "The harmonic mean of precision and recall.", "cat": "Data"},
  {"term": "Feature Engineering", "def": "The process of using domain knowledge to extract features from raw data.", "cat": "Data"},
  {"term": "Hadoop", "def": "A collection of open-source software utilities that facilitate using a network of many computers to solve problems involving massive amounts of data.", "cat": "Data"},
  {"term": "Hypothesis Testing", "def": "An act in statistics whereby an analyst tests an assumption regarding a population parameter.", "cat": "Data"},
  {"term": "K-Means", "def": "A method of vector quantization, originally from signal processing, popular for cluster analysis.", "cat": "Data"},
  {"term": "KNN", "def": "K-Nearest Neighbors. A non-parametric method used for classification and regression.", "cat": "Data"},
  {"term": "Linear Regression", "def": "A linear approach to modeling the relationship between a scalar response and one or more explanatory variables.", "cat": "Data"},
  {"term": "Logistic Regression", "def": "A statistical model that in its basic form uses a logistic function to model a binary dependent variable.", "cat": "Data"},
  {"term": "Matplotlib", "def": "A plotting library for the Python programming language.", "cat": "Data"},
  {"term": "Mean", "def": "The average of a set of numbers.", "cat": "Data"},
  {"term": "Median", "def": "The middle number in a sorted list of numbers.", "cat": "Data"},
  {"term": "Mode", "def": "The value that appears most often in a set of data.", "cat": "Data"},
  {"term": "Naive Bayes", "def": "A simple technique for constructing classifiers based on Bayes' theorem.", "cat": "Data"},
  {"term": "Normalization", "def": "Adjusting values measured on different scales to a notionally common scale.", "cat": "Data"},
  {"term": "NoSQL", "def": "A mechanism for storage and retrieval of data that is modeled in means other than the tabular relations used in relational databases.", "cat": "Data"},
  {"term": "Null Hypothesis", "def": "The hypothesis that there is no significant difference between specified populations.", "cat": "Data"},
  {"term": "NumPy", "def": "A library for the Python programming language, adding support for large, multi-dimensional arrays and matrices.", "cat": "Data"},
  {"term": "Outlier", "def": "A data point that differs significantly from other observations.", "cat": "Data"},
  {"term": "P-Value", "def": "The probability of obtaining test results at least as extreme as the results actually observed.", "cat": "Data"},
  {"term": "Pandas", "def": "A software library written for the Python programming language for data manipulation and analysis.", "cat": "Data"},
  {"term": "PCA", "def": "Principal Component Analysis. A statistical procedure that uses an orthogonal transformation.", "cat": "Data"},
  {"term": "Precision", "def": "The number of true positives divided by the total number of positive predictions.", "cat": "Data"},
  {"term": "Predictive Modeling", "def": "A process that uses data and statistics to predict outcomes.", "cat": "Data"},
  {"term": "Qualitative Data", "def": "Data that approximates or characterizes but does not measure the attributes.", "cat": "Data"},
  {"term": "Quantitative Data", "def": "Data expressing a certain quantity, amount or range.", "cat": "Data"},
  {"term": "R Language", "def": "A programming language and free software environment for statistical computing.", "cat": "Data"},
  {"term": "Random Forest", "def": "An ensemble learning method for classification and regression.", "cat": "Data"},
  {"term": "Recall", "def": "The number of true positives divided by the total number of elements that actually belong to the positive class.", "cat": "Data"},
  {"term": "Regression", "def": "A set of statistical processes for estimating the relationships between a dependent variable and one or more independent variables.", "cat": "Data"},
  {"term": "ROC Curve", "def": "Receiver Operating Characteristic. A graphical plot that illustrates the diagnostic ability of a binary classifier.", "cat": "Data"},
  {"term": "Scikit-learn", "def": "A free software machine learning library for the Python programming language.", "cat": "Data"},
  {"term": "SQL", "def": "Structured Query Language. A domain-specific language used in programming and designed for managing data held in a RDBMS.", "cat": "Data"},
  {"term": "Standard Deviation", "def": "A quantity calculating to indicate the extent of deviation for a group as a whole.", "cat": "Data"},
  {"term": "SVM", "def": "Support Vector Machine. A supervised learning model with associated learning algorithms that analyze data for classification.", "cat": "Data"},
  {"term": "Tableau", "def": "Interactive data visualization software.", "cat": "Data"},
  {"term": "Time Series", "def": "A series of data points indexed in time order.", "cat": "Data"},
  {"term": "Unstructured Data", "def": "Information that either does not have a pre-defined data model or is not organized in a pre-defined manner.", "cat": "Data"},
  {"term": "Variance", "def": "The expectation of the squared deviation of a random variable from its mean.", "cat": "Data"},
  {"term": "Web Scraping", "def": "Data scraping used for extracting data from websites.", "cat": "Data"},
  {"term": "Z-Score", "def": "The number of standard deviations by which the value of a raw score is above or below the mean value.", "cat": "Data"},

  // --- DEVOPS ---
  {"term": "Agile", "def": "A project management methodology characterized by the division of tasks into short phases of work.", "cat": "DevOps"},
  {"term": "Ansible", "def": "An open-source software provisioning, configuration management, and application-deployment tool.", "cat": "DevOps"},
  {"term": "Artifact", "def": "One of many kinds of tangible by-products produced during the development of software.", "cat": "DevOps"},
  {"term": "Automation", "def": "The use of instructions to create a repeated process that replaces manual work.", "cat": "DevOps"},
  {"term": "Bash", "def": "A Unix shell and command language.", "cat": "DevOps"},
  {"term": "Blue-Green Deployment", "def": "A technique that reduces downtime and risk by running two identical production environments.", "cat": "DevOps"},
  {"term": "Build Automation", "def": "Scripting or automating the process of compiling computer source code into binary code.", "cat": "DevOps"},
  {"term": "Canary Release", "def": "A technique to reduce the risk of introducing a new software version in production by slowly rolling out the change.", "cat": "DevOps"},
  {"term": "Chaos Engineering", "def": "The discipline of experimenting on a system in order to build confidence in the system's capability to withstand turbulent conditions.", "cat": "DevOps"},
  {"term": "Chef", "def": "A configuration management tool written in Ruby and Erlang.", "cat": "DevOps"},
  {"term": "CI/CD", "def": "Continuous Integration and Continuous Delivery/Deployment.", "cat": "DevOps"},
  {"term": "Cloud Native", "def": "Building and running applications to take full advantage of the distributed computing offered by the cloud delivery model.", "cat": "DevOps"},
  {"term": "Cluster", "def": "A set of loosely or tightly connected computers that work together.", "cat": "DevOps"},
  {"term": "Configuration Management", "def": "A process for establishing and maintaining consistency of a product's performance.", "cat": "DevOps"},
  {"term": "Container", "def": "A standard unit of software that packages up code and all its dependencies.", "cat": "DevOps"},
  {"term": "Continuous Deployment", "def": "A software engineering approach in which software functionalities are delivered frequently through automated deployments.", "cat": "DevOps"},
  {"term": "Continuous Integration", "def": "The practice of merging all developers' working copies to a shared mainline several times a day.", "cat": "DevOps"},
  {"term": "Cron", "def": "A time-based job scheduler in Unix-like computer operating systems.", "cat": "DevOps"},
  {"term": "Dark Launch", "def": "A process of releasing a production-ready software feature to a subset of users before it is widely released.", "cat": "DevOps"},
  {"term": "Datadog", "def": "A monitoring service for cloud-scale applications.", "cat": "DevOps"},
  {"term": "DevSecOps", "def": "Integrating security practices within the DevOps process.", "cat": "DevOps"},
  {"term": "Docker", "def": "A set of platform as a service products that use OS-level virtualization to deliver software in packages called containers.", "cat": "DevOps"},
  {"term": "Docker Compose", "def": "A tool for defining and running multi-container Docker applications.", "cat": "DevOps"},
  {"term": "Dockerfile", "def": "A text document that contains all the commands a user could call on the command line to assemble an image.", "cat": "DevOps"},
  {"term": "Downtime", "def": "Periods when a system is unavailable.", "cat": "DevOps"},
  {"term": "Elasticsearch", "def": "A search engine based on the Lucene library.", "cat": "DevOps"},
  {"term": "ELK Stack", "def": "Elasticsearch, Logstash, and Kibana. A tech stack used to search, analyze, and visualize log data.", "cat": "DevOps"},
  {"term": "Failover", "def": "Switching to a redundant or standby computer server upon the failure of the previously active application.", "cat": "DevOps"},
  {"term": "Feature Flag", "def": "A technique to turn some functionality of an application on and off.", "cat": "DevOps"},
  {"term": "Git", "def": "A distributed version-control system for tracking changes in source code.", "cat": "DevOps"},
  {"term": "GitHub Actions", "def": "A CI/CD platform that allows you to automate your build, test, and deployment pipeline.", "cat": "DevOps"},
  {"term": "GitLab", "def": "A web-based DevOps lifecycle tool.", "cat": "DevOps"},
  {"term": "GitOps", "def": "A way of implementing Continuous Deployment for cloud native applications.", "cat": "DevOps"},
  {"term": "Grafana", "def": "A multi-platform open source analytics and interactive visualization web application.", "cat": "DevOps"},
  {"term": "Helm", "def": "A package manager for Kubernetes.", "cat": "DevOps"},
  {"term": "High Availability", "def": "A characteristic of a system which aims to ensure an agreed level of operational performance.", "cat": "DevOps"},
  {"term": "IaC", "def": "Infrastructure as Code. Managing and provisioning computer data centers through machine-readable definition files.", "cat": "DevOps"},
  {"term": "Immutable Infrastructure", "def": "An infrastructure paradigm in which servers are never modified after they're deployed.", "cat": "DevOps"},
  {"term": "Incident Management", "def": "The process used by DevOps and IT Operations teams to respond to an unplanned event or service interruption.", "cat": "DevOps"},
  {"term": "Jenkins", "def": "An open source automation server.", "cat": "DevOps"},
  {"term": "Jira", "def": "A proprietary issue tracking product developed by Atlassian.", "cat": "DevOps"},
  {"term": "Kanban", "def": "A scheduling system for lean manufacturing and just-in-time manufacturing.", "cat": "DevOps"},
  {"term": "Kibana", "def": "An open source data visualization dashboard for Elasticsearch.", "cat": "DevOps"},
  {"term": "Kubernetes", "def": "An open-source container-orchestration system for automating computer application deployment, scaling, and management.", "cat": "DevOps"},
  {"term": "Latency", "def": "The delay before a transfer of data begins following an instruction.", "cat": "DevOps"},
  {"term": "Load Balancer", "def": "A device that acts as a reverse proxy and distributes network or application traffic across a number of servers.", "cat": "DevOps"},
  {"term": "Logstash", "def": "A server-side data processing pipeline that ingests data from multiple sources simultaneously.", "cat": "DevOps"},
  {"term": "Microservices", "def": "A variant of the service-oriented architecture style that structures an application as a collection of loosely coupled services.", "cat": "DevOps"},
  {"term": "Monitoring", "def": "The process of observing and checking the progress or quality of something over a period of time.", "cat": "DevOps"},
  {"term": "Monolith", "def": "A software application in which different components are combined into a single program from a single platform.", "cat": "DevOps"},
  {"term": "Nagios", "def": "A free and open source computer-software application that monitors systems, networks and infrastructure.", "cat": "DevOps"},
  {"term": "Nginx", "def": "A web server that can also be used as a reverse proxy, load balancer, mail proxy and HTTP cache.", "cat": "DevOps"},
  {"term": "Orchestration", "def": "The automated configuration, coordination, and management of computer systems and software.", "cat": "DevOps"},
  {"term": "Pipeline", "def": "A set of automated processes that allows developers and DevOps professionals to compile, build, and deploy code.", "cat": "DevOps"},
  {"term": "Platform Engineering", "def": "The discipline of designing and building toolchains and workflows that enable self-service capabilities.", "cat": "DevOps"},
  {"term": "Pod", "def": "The smallest deployable units of computing that you can create and manage in Kubernetes.", "cat": "DevOps"},
  {"term": "Prometheus", "def": "A free software application used for event monitoring and alerting.", "cat": "DevOps"},
  {"term": "Provisioning", "def": "The process of setting up IT infrastructure.", "cat": "DevOps"},
  {"term": "Puppet", "def": "A software configuration management tool.", "cat": "DevOps"},
  {"term": "Regression Testing", "def": "Re-running functional and non-functional tests to ensure that previously developed and tested software still performs after a change.", "cat": "DevOps"},
  {"term": "Reliability", "def": "The probability that a system will produce correct outputs up to some given time.", "cat": "DevOps"},
  {"term": "Rollback", "def": "The operation of returning a database or other system to a previous state.", "cat": "DevOps"},
  {"term": "Runbook", "def": "A compilation of routine procedures and operations that the system administrator or operator carries out.", "cat": "DevOps"},
  {"term": "Scalability", "def": "The capability of a system, network, or process to handle a growing amount of work.", "cat": "DevOps"},
  {"term": "Scrum", "def": "An agile framework for developing, delivering, and sustaining complex products.", "cat": "DevOps"},
  {"term": "Serverless", "def": "A cloud computing execution model in which the cloud provider runs the server, and dynamically manages the allocation of machine resources.", "cat": "DevOps"},
  {"term": "Service Mesh", "def": "A dedicated infrastructure layer for facilitating service-to-service communications between microservices.", "cat": "DevOps"},
  {"term": "SLA", "def": "Service Level Agreement. A commitment between a service provider and a client.", "cat": "DevOps"},
  {"term": "SLI", "def": "Service Level Indicator. A quantitative measure of some aspect of the level of service.", "cat": "DevOps"},
  {"term": "SLO", "def": "Service Level Objective. A target value or range of values for a service level that is measured by an SLI.", "cat": "DevOps"},
  {"term": "SRE", "def": "Site Reliability Engineering. A discipline that incorporates aspects of software engineering and applies them to infrastructure and operations problems.", "cat": "DevOps"},
  {"term": "Staging", "def": "An environment used for testing purposes that exactly resembles the production environment.", "cat": "DevOps"},
  {"term": "Terraform", "def": "An open-source infrastructure as code software tool created by HashiCorp.", "cat": "DevOps"},
  {"term": "Test Automation", "def": "The use of software separate from the software being tested to control the execution of tests.", "cat": "DevOps"},
  {"term": "Unit Testing", "def": "A software testing method by which individual units of source code are tested.", "cat": "DevOps"},
  {"term": "Uptime", "def": "A measure of the time a machine has been working and available.", "cat": "DevOps"},
  {"term": "Vagrant", "def": "A tool for building and managing virtual machine environments.", "cat": "DevOps"},
  {"term": "Version Control", "def": "The management of changes to documents, computer programs, large web sites, and other collections of information.", "cat": "DevOps"},
  {"term": "Virtual Machine", "def": "An emulation of a computer system.", "cat": "DevOps"},
  {"term": "Virtualization", "def": "The act of creating a virtual version of something, including virtual computer hardware platforms.", "cat": "DevOps"},
  {"term": "Waterfall", "def": "A breakdown of project activities into linear sequential phases.", "cat": "DevOps"},
  {"term": "YAML", "def": "A human-readable data-serialization language.", "cat": "DevOps"},
  {"term": "Zero Downtime", "def": "A site or application is available 100% of the time, even during upgrades.", "cat": "DevOps"},

  // --- CLOUD COMPUTING ---
  {"term": "AWS", "def": "Amazon Web Services. The world's most comprehensive and broadly adopted cloud platform.", "cat": "Cloud"},
  {"term": "Azure", "def": "Microsoft's public cloud computing platform.", "cat": "Cloud"},
  {"term": "Blob Storage", "def": "A feature in Microsoft Azure that lets you create data lakes for your analytics needs.", "cat": "Cloud"},
  {"term": "CDN", "def": "Content Delivery Network. A geographically distributed group of servers which work together to provide fast delivery of Internet content.", "cat": "Cloud"},
  {"term": "Cloud Formation", "def": "An AWS service that helps you model and set up your Amazon Web Services resources.", "cat": "Cloud"},
  {"term": "Cloud Provider", "def": "A company that offers some component of cloud computing – typically IaaS, SaaS or PaaS.", "cat": "Cloud"},
  {"term": "Cold Storage", "def": "Data storage that is rarely accessed and is stored on lower-cost devices.", "cat": "Cloud"},
  {"term": "Compute Engine", "def": "Secure and customizable compute service that lets you create and run virtual machines on Google's infrastructure.", "cat": "Cloud"},
  {"term": "EC2", "def": "Elastic Compute Cloud. A web service that provides secure, resizable compute capacity in the cloud.", "cat": "Cloud"},
  {"term": "Edge Computing", "def": "A distributed computing paradigm that brings computation and data storage closer to the sources of data.", "cat": "Cloud"},
  {"term": "Elasticity", "def": "The ability of a system to adapt to workload changes by provisioning and de-provisioning resources in an autonomic manner.", "cat": "Cloud"},
  {"term": "FaaS", "def": "Function as a Service. A category of cloud computing services that provides a platform allowing customers to develop, run, and manage application functionalities without the complexity of building and maintaining the infrastructure.", "cat": "Cloud"},
  {"term": "GCP", "def": "Google Cloud Platform. A suite of cloud computing services that runs on the same infrastructure that Google uses internally.", "cat": "Cloud"},
  {"term": "Hybrid Cloud", "def": "A computing environment that combines a public cloud and a private cloud by allowing data and applications to be shared between them.", "cat": "Cloud"},
  {"term": "IaaS", "def": "Infrastructure as a Service. Online services that provide high-level APIs used to dereference various low-level details of underlying network infrastructure.", "cat": "Cloud"},
  {"term": "IAM", "def": "Identity and Access Management. A framework of policies and technologies for ensuring that the proper people have the appropriate access.", "cat": "Cloud"},
  {"term": "Lambda", "def": "An event-driven, serverless computing platform provided by Amazon.", "cat": "Cloud"},
  {"term": "Load Balancing", "def": "The process of distributing network traffic across multiple servers.", "cat": "Cloud"},
  {"term": "Multi-Cloud", "def": "The use of multiple cloud computing and storage services in a single heterogeneous architecture.", "cat": "Cloud"},
  {"term": "Object Storage", "def": "A computer data storage architecture that manages data as objects, as opposed to other computer data storage architectures like file systems.", "cat": "Cloud"},
  {"term": "On-Premises", "def": "Installed and runs on computers on the premises of the person or organization using the software.", "cat": "Cloud"},
  {"term": "PaaS", "def": "Platform as a Service. A cloud computing model where a third-party provider delivers hardware and software tools to users over the internet.", "cat": "Cloud"},
  {"term": "Private Cloud", "def": "A model of cloud computing where IT services are provisioned over private IT infrastructure for the dedicated use of a single organization.", "cat": "Cloud"},
  {"term": "Public Cloud", "def": "A type of computing in which a service provider makes resources available to the public via the internet.", "cat": "Cloud"},
  {"term": "Region", "def": "A separate geographic area.", "cat": "Cloud"},
  {"term": "S3", "def": "Simple Storage Service. A service offered by Amazon Web Services that provides object storage through a web service interface.", "cat": "Cloud"},
  {"term": "SaaS", "def": "Software as a Service. A software licensing and delivery model in which software is licensed on a subscription basis and is centrally hosted.", "cat": "Cloud"},
  {"term": "Scalability", "def": "The ability of a system to handle a growing amount of work.", "cat": "Cloud"},
  {"term": "Serverless", "def": "A cloud computing execution model in which the cloud provider runs the server, and dynamically manages the allocation of machine resources.", "cat": "Cloud"},
  {"term": "Snapshot", "def": "A copy of the state of a system at a particular point in time.", "cat": "Cloud"},
  {"term": "Virtual Private Cloud", "def": "VPC. An on-demand configurable pool of shared computing resources allocated within a public cloud environment.", "cat": "Cloud"},
  {"term": "Virtualization", "def": "The act of creating a virtual version of something.", "cat": "Cloud"},
  {"term": "VM", "def": "Virtual Machine. An emulation of a computer system.", "cat": "Cloud"},
  {"term": "Zone", "def": "A deployment area within a region.", "cat": "Cloud"},

  // --- WEB3 & BLOCKCHAIN ---
  {"term": "51% Attack", "def": "An attack on a blockchain by a group of miners who control more than 50% of the network's mining hashrate.", "cat": "Web3"},
  {"term": "Address", "def": "A string of characters that represents a destination for a crypto payment.", "cat": "Web3"},
  {"term": "Airdrop", "def": "A marketing stunt that involves sending coins or tokens to wallet addresses in order to promote awareness of a new virtual currency.", "cat": "Web3"},
  {"term": "Altcoin", "def": "Alternative Coin. Any cryptocurrency other than Bitcoin.", "cat": "Web3"},
  {"term": "Bitcoin", "def": "A decentralized digital currency, without a central bank or single administrator.", "cat": "Web3"},
  {"term": "Blockchain", "def": "A growing list of records, called blocks, that are linked using cryptography.", "cat": "Web3"},
  {"term": "Bridge", "def": "A connection that allows the transfer of tokens or arbitrary data from one blockchain to another.", "cat": "Web3"},
  {"term": "Cold Wallet", "def": "An offline wallet used for storing cryptocurrencies.", "cat": "Web3"},
  {"term": "Consensus Mechanism", "def": "A fault-tolerant mechanism that is used in computer and blockchain systems to achieve the necessary agreement on a single data value.", "cat": "Web3"},
  {"term": "DAO", "def": "Decentralized Autonomous Organization. An organization represented by rules encoded as a computer program that is transparent, controlled by the organization members and not influenced by a central government.", "cat": "Web3"},
  {"term": "DApp", "def": "Decentralized Application. A computer application that runs on a decentralized computing system.", "cat": "Web3"},
  {"term": "DeFi", "def": "Decentralized Finance. A blockchain-based form of finance that does not rely on central financial intermediaries.", "cat": "Web3"},
  {"term": "Ethereum", "def": "A decentralized, open-source blockchain with smart contract functionality.", "cat": "Web3"},
  {"term": "Fork", "def": "A split in the blockchain network.", "cat": "Web3"},
  {"term": "Gas", "def": "A fee paid to execute a transaction on the Ethereum blockchain.", "cat": "Web3"},
  {"term": "Hash Rate", "def": "The measure of the computational power of a cryptocurrency network.", "cat": "Web3"},
  {"term": "Hot Wallet", "def": "A cryptocurrency wallet that is connected to the internet.", "cat": "Web3"},
  {"term": "ICO", "def": "Initial Coin Offering. A type of funding using cryptocurrencies.", "cat": "Web3"},
  {"term": "Layer 1", "def": "The underlying main blockchain architecture.", "cat": "Web3"},
  {"term": "Layer 2", "def": "A secondary framework or protocol that is built on top of an existing blockchain system.", "cat": "Web3"},
  {"term": "Ledger", "def": "A record-keeping system.", "cat": "Web3"},
  {"term": "Mining", "def": "The process of adding transactions to the large distributed public ledger of existing transactions.", "cat": "Web3"},
  {"term": "Minting", "def": "The process of generating new coins or tokens.", "cat": "Web3"},
  {"term": "NFT", "def": "Non-Fungible Token. A unique digital identifier that cannot be copied, substituted, or subdivided.", "cat": "Web3"},
  {"term": "Node", "def": "A computer that connects to a blockchain network and supports the network.", "cat": "Web3"},
  {"term": "Oracle", "def": "Third-party services that provide smart contracts with external information.", "cat": "Web3"},
  {"term": "PoS", "def": "Proof of Stake. A type of consensus mechanism by which a cryptocurrency blockchain network achieves distributed consensus.", "cat": "Web3"},
  {"term": "PoW", "def": "Proof of Work. A form of cryptographic zero-knowledge proof.", "cat": "Web3"},
  {"term": "Private Key", "def": "A sophisticated form of cryptography that allows a user to access their cryptocurrency.", "cat": "Web3"},
  {"term": "Public Key", "def": "A cryptographic code that allows a user to receive cryptocurrency into their account.", "cat": "Web3"},
  {"term": "RPC", "def": "Remote Procedure Call. A protocol that one program can use to request a service from a program located in another computer.", "cat": "Web3"},
  {"term": "Satoshi", "def": "The smallest unit of the bitcoin cryptocurrency.", "cat": "Web3"},
  {"term": "Smart Contract", "def": "A self-executing contract with the terms of the agreement between buyer and seller being directly written into lines of code.", "cat": "Web3"},
  {"term": "Solidity", "def": "An object-oriented programming language for writing smart contracts.", "cat": "Web3"},
  {"term": "Stablecoin", "def": "Cryptocurrencies where the price is designed to be pegged to a cryptocurrency, fiat money, or to exchange-traded commodities.", "cat": "Web3"},
  {"term": "Token", "def": "A unit of value issued by a tech or crypto organization.", "cat": "Web3"},
  {"term": "Wallet", "def": "A device, physical medium, program or a service which stores the public and/or private keys.", "cat": "Web3"},
  {"term": "Web3", "def": "An idea for a new iteration of the World Wide Web which incorporates concepts such as decentralization, blockchain technologies, and token-based economics.", "cat": "Web3"},
  {"term": "Whitelist", "def": "A list of approved participants for a crypto event.", "cat": "Web3"},
  {"term": "zk-Rollup", "def": "Zero-Knowledge Rollup. A Layer 2 scaling solution that bundles transactions and submits a validity proof to the main chain.", "cat": "Web3"},

  // --- MOBILE DEVELOPMENT ---
  {"term": "AAB", "def": "Android App Bundle. The official publishing format for Android apps.", "cat": "Mobile"},
  {"term": "Activity", "def": "A single, focused thing that the user can do.", "cat": "Mobile"},
  {"term": "ADB", "def": "Android Debug Bridge. A versatile command-line tool that lets you communicate with a device.", "cat": "Mobile"},
  {"term": "Android", "def": "A mobile operating system based on a modified version of the Linux kernel.", "cat": "Mobile"},
  {"term": "APK", "def": "Android Package Kit. The package file format used by the Android operating system.", "cat": "Mobile"},
  {"term": "App Store", "def": "A digital distribution platform for mobile apps on iOS.", "cat": "Mobile"},
  {"term": "Bundle ID", "def": "A unique identifier for an iOS app.", "cat": "Mobile"},
  {"term": "CocoaPods", "def": "A dependency manager for Swift and Objective-C Cocoa projects.", "cat": "Mobile"},
  {"term": "Composable", "def": "A modern toolkit for building native UI.", "cat": "Mobile"},
  {"term": "Cross-Platform", "def": "Software that can run on multiple computing platforms.", "cat": "Mobile"},
  {"term": "Dart", "def": "A client-optimized programming language for apps on multiple platforms.", "cat": "Mobile"},
  {"term": "Emulator", "def": "Hardware or software that enables one computer system to behave like another computer system.", "cat": "Mobile"},
  {"term": "Expo", "def": "A framework and a platform for universal React applications.", "cat": "Mobile"},
  {"term": "Firebase", "def": "A platform developed by Google for creating mobile and web applications.", "cat": "Mobile"},
  {"term": "Flutter", "def": "An open-source UI software development kit created by Google.", "cat": "Mobile"},
  {"term": "Fragment", "def": "A portion of user interface in an Activity.", "cat": "Mobile"},
  {"term": "Gradle", "def": "An open-source build automation system.", "cat": "Mobile"},
  {"term": "Hybrid App", "def": "An application that combines elements of both native apps and web applications.", "cat": "Mobile"},
  {"term": "Intent", "def": "A messaging object you can use to request an action from another app component.", "cat": "Mobile"},
  {"term": "iOS", "def": "A mobile operating system created and developed by Apple Inc.", "cat": "Mobile"},
  {"term": "IPA", "def": "iOS App Store Package. An application archive file which stores an iOS app.", "cat": "Mobile"},
  {"term": "Jetpack Compose", "def": "Android's modern toolkit for building native UI.", "cat": "Mobile"},
  {"term": "Kotlin", "def": "A cross-platform, statically typed, general-purpose programming language with type inference.", "cat": "Mobile"},
  {"term": "Manifest", "def": "A file that describes essential information about an app to the Android build tools.", "cat": "Mobile"},
  {"term": "Material Design", "def": "A design language developed by Google.", "cat": "Mobile"},
  {"term": "Native App", "def": "A software application built for use on a specific platform or device.", "cat": "Mobile"},
  {"term": "Play Store", "def": "Google's official app store.", "cat": "Mobile"},
  {"term": "PWA", "def": "Progressive Web App. A type of application software delivered through the web.", "cat": "Mobile"},
  {"term": "React Native", "def": "An open-source UI software framework created by Meta Platforms.", "cat": "Mobile"},
  {"term": "Simulator", "def": "A program that simulates the behavior of a device.", "cat": "Mobile"},
  {"term": "Swift", "def": "A general-purpose, multi-paradigm, compiled programming language developed by Apple.", "cat": "Mobile"},
  {"term": "SwiftUI", "def": "An innovative, exceptionally simple way to build user interfaces across all Apple platforms.", "cat": "Mobile"},
  {"term": "TestFlight", "def": "An online service for over-the-air installation and testing of mobile applications.", "cat": "Mobile"},
  {"term": "Widget", "def": "A small application that can be installed and executed within a web page or device.", "cat": "Mobile"},
  {"term": "Xcode", "def": "Apple's integrated development environment for macOS.", "cat": "Mobile"},

  // --- IOT ---
  {"term": "Actuator", "def": "A component of a machine that is responsible for moving and controlling a mechanism or system.", "cat": "IoT"},
  {"term": "Arduino", "def": "An open-source hardware and software company, project and user community that designs and manufactures single-board microcontrollers.", "cat": "IoT"},
  {"term": "Bluetooth", "def": "A short-range wireless technology standard that is used for exchanging data between fixed and mobile devices.", "cat": "IoT"},
  {"term": "CoAP", "def": "Constrained Application Protocol. A specialized web transfer protocol for use with constrained nodes and constrained networks.", "cat": "IoT"},
  {"term": "Edge Computing", "def": "A distributed computing paradigm that brings computation and data storage closer to the sources of data.", "cat": "IoT"},
  {"term": "Embedded System", "def": "A computer system—a combination of a computer processor, computer memory, and input/output peripheral devices—that has a dedicated function within a larger mechanical or electronic system.", "cat": "IoT"},
  {"term": "ESP32", "def": "A series of low-cost, low-power system on a chip microcontrollers with integrated Wi-Fi and dual-mode Bluetooth.", "cat": "IoT"},
  {"term": "Firmware", "def": "Specific class of computer software that provides the low-level control for a device's specific hardware.", "cat": "IoT"},
  {"term": "Gateway", "def": "A piece of networking hardware used in telecommunications for telecommunications networks that allows data to flow from one discrete network to another.", "cat": "IoT"},
  {"term": "GPIO", "def": "General-purpose input/output. An uncommitted digital signal pin on an integrated circuit or electronic circuit board.", "cat": "IoT"},
  {"term": "I2C", "def": "Inter-Integrated Circuit. A synchronous, multi-master, multi-slave, packet switched, single-ended, serial computer bus.", "cat": "IoT"},
  {"term": "Industrial IoT", "def": "IIoT. The use of smart sensors and actuators to enhance manufacturing and industrial processes.", "cat": "IoT"},
  {"term": "LoRaWAN", "def": "Long Range Wide Area Network. A low-power, wide-area networking protocol.", "cat": "IoT"},
  {"term": "M2M", "def": "Machine to Machine. Direct communication between devices using any communications channel.", "cat": "IoT"},
  {"term": "Microcontroller", "def": "A small computer on a single metal-oxide-semiconductor integrated circuit.", "cat": "IoT"},
  {"term": "MQTT", "def": "Message Queuing Telemetry Transport. A lightweight, publish-subscribe network protocol that transports messages between devices.", "cat": "IoT"},
  {"term": "NFC", "def": "Near-Field Communication. A set of communication protocols for communication between two electronic devices over a distance of 4 cm or less.", "cat": "IoT"},
  {"term": "PCB", "def": "Printed Circuit Board. A medium used in electrical and electronic engineering to connect electronic components.", "cat": "IoT"},
  {"term": "Raspberry Pi", "def": "A series of small single-board computers developed in the United Kingdom by the Raspberry Pi Foundation.", "cat": "IoT"},
  {"term": "RFID", "def": "Radio-Frequency Identification. Uses electromagnetic fields to automatically identify and track tags attached to objects.", "cat": "IoT"},
  {"term": "RTOS", "def": "Real-Time Operating System. An operating system intended to serve real-time applications that process data as it comes in.", "cat": "IoT"},
  {"term": "Sensor", "def": "A device, module, machine, or subsystem whose purpose is to detect events or changes in its environment and send the information to other electronics.", "cat": "IoT"},
  {"term": "Smart Home", "def": "A home equipped with lighting, heating, and electronic devices that can be controlled remotely by phone or computer.", "cat": "IoT"},
  {"term": "SPI", "def": "Serial Peripheral Interface. A synchronous serial communication interface specification used for short distance communication.", "cat": "IoT"},
  {"term": "UART", "def": "Universal Asynchronous Receiver-Transmitter. A computer hardware device for asynchronous serial communication.", "cat": "IoT"},
  {"term": "Zigbee", "def": "An IEEE 802.15.4-based specification for a suite of high-level communication protocols used to create personal area networks with small, low-power digital radios.", "cat": "IoT"},

  // --- FULL STACK & CODE ---
  {"term": "AJAX", "def": "Asynchronous JavaScript and XML.", "cat": "Code"},
  {"term": "API", "def": "Application Programming Interface.", "cat": "Code"},
  {"term": "Async/Await", "def": "Syntactic sugar for writing asynchronous code.", "cat": "Code"},
  {"term": "Backend", "def": "The server-side of an application.", "cat": "Code"},
  {"term": "Bootstrap", "def": "A free and open-source CSS framework.", "cat": "Code"},
  {"term": "Callback", "def": "A function passed into another function as an argument.", "cat": "Code"},
  {"term": "Closure", "def": "The combination of a function bundled together with references to its surrounding state.", "cat": "Code"},
  {"term": "CMS", "def": "Content Management System.", "cat": "Code"},
  {"term": "CRUD", "def": "Create, Read, Update, Delete.", "cat": "Code"},
  {"term": "CSS", "def": "Cascading Style Sheets.", "cat": "Code"},
  {"term": "DOM", "def": "Document Object Model.", "cat": "Code"},
  {"term": "Framework", "def": "A platform for developing software applications.", "cat": "Code"},
  {"term": "Frontend", "def": "The client-side of an application.", "cat": "Code"},
  {"term": "Git", "def": "A version control system.", "cat": "Code"},
  {"term": "GraphQL", "def": "A query language for APIs.", "cat": "Code"},
  {"term": "HTML", "def": "HyperText Markup Language.", "cat": "Code"},
  {"term": "HTTP", "def": "Hypertext Transfer Protocol.", "cat": "Code"},
  {"term": "Jamstack", "def": "JavaScript, APIs, and Markup.", "cat": "Code"},
  {"term": "JavaScript", "def": "A programming language.", "cat": "Code"},
  {"term": "JSON", "def": "JavaScript Object Notation.", "cat": "Code"},
  {"term": "JWT", "def": "JSON Web Token.", "cat": "Code"},
  {"term": "Library", "def": "A collection of non-volatile resources used by computer programs.", "cat": "Code"},
  {"term": "MVC", "def": "Model-View-Controller.", "cat": "Code"},
  {"term": "Node.js", "def": "A JavaScript runtime built on Chrome's V8 JavaScript engine.", "cat": "Code"},
  {"term": "NoSQL", "def": "Non-relational database.", "cat": "Code"},
  {"term": "NPM", "def": "Node Package Manager.", "cat": "Code"},
  {"term": "OAuth", "def": "Open Authorization.", "cat": "Code"},
  {"term": "ORM", "def": "Object-Relational Mapping.", "cat": "Code"},
  {"term": "Promise", "def": "An object representing the eventual completion or failure of an asynchronous operation.", "cat": "Code"},
  {"term": "PWA", "def": "Progressive Web App.", "cat": "Code"},
  {"term": "React", "def": "A JavaScript library for building user interfaces.", "cat": "Code"},
  {"term": "REST", "def": "Representational State Transfer.", "cat": "Code"},
  {"term": "Responsive Design", "def": "An approach to web design that makes web pages render well on a variety of devices.", "cat": "Code"},
  {"term": "SaaS", "def": "Software as a Service.", "cat": "Code"},
  {"term": "SEO", "def": "Search Engine Optimization.", "cat": "Code"},
  {"term": "SPA", "def": "Single Page Application.", "cat": "Code"},
  {"term": "SQL", "def": "Structured Query Language.", "cat": "Code"},
  {"term": "SSR", "def": "Server-Side Rendering.", "cat": "Code"},
  {"term": "Stack", "def": "A combination of software products and programming languages.", "cat": "Code"},
  {"term": "TypeScript", "def": "A strict syntactical superset of JavaScript.", "cat": "Code"},
  {"term": "UI", "def": "User Interface.", "cat": "Code"},
  {"term": "UX", "def": "User Experience.", "cat": "Code"},
  {"term": "Vue", "def": "A progressive JavaScript framework.", "cat": "Code"},
  {"term": "WebAssembly", "def": "Wasm. A binary instruction format for a stack-based virtual machine.", "cat": "Code"},
  {"term": "Webpack", "def": "A static module bundler for modern JavaScript applications.", "cat": "Code"},
  {"term": "WebSocket", "def": "A computer communications protocol.", "cat": "Code"},

  // --- CS FOUNDATIONS ---
  {"term": "Abstraction", "def": "The process of removing physical, spatial, or temporal details.", "cat": "CS"},
  {"term": "Algorithm", "def": "A step-by-step procedure for calculations.", "cat": "CS"},
  {"term": "Array", "def": "A data structure consisting of a collection of elements.", "cat": "CS"},
  {"term": "Big O Notation", "def": "A mathematical notation that describes the limiting behavior of a function.", "cat": "CS"},
  {"term": "Binary", "def": "A base-2 number system.", "cat": "CS"},
  {"term": "Bit", "def": "The basic unit of information in computing.", "cat": "CS"},
  {"term": "Boolean", "def": "A data type that has one of two possible values.", "cat": "CS"},
  {"term": "Byte", "def": "A unit of digital information that most commonly consists of eight bits.", "cat": "CS"},
  {"term": "Cache", "def": "A hardware or software component that stores data so that future requests for that data can be served faster.", "cat": "CS"},
  {"term": "Compiler", "def": "A computer program that translates computer code written in one programming language into another language.", "cat": "CS"},
  {"term": "Concurrency", "def": "The ability of different parts or units of a program, algorithm, or problem to be executed out-of-order or in partial order.", "cat": "CS"},
  {"term": "Data Structure", "def": "A data organization, management, and storage format.", "cat": "CS"},
  {"term": "Deadlock", "def": "A state in which each member of a group is waiting for another member, including itself, to take action.", "cat": "CS"},
  {"term": "Debugging", "def": "The process of finding and resolving defects or problems within a computer program.", "cat": "CS"},
  {"term": "Encapsulation", "def": "The bundling of data with the methods that operate on that data.", "cat": "CS"},
  {"term": "Function", "def": "A block of organized, reusable code that is used to perform a single, related action.", "cat": "CS"},
  {"term": "Garbage Collection", "def": "A form of automatic memory management.", "cat": "CS"},
  {"term": "Hash Table", "def": "A data structure that implements an associative array abstract data type.", "cat": "CS"},
  {"term": "Heap", "def": "A specialized tree-based data structure.", "cat": "CS"},
  {"term": "Inheritance", "def": "The mechanism of basing an object or class upon another object or class.", "cat": "CS"},
  {"term": "Interpreter", "def": "A computer program that directly executes instructions written in a programming or scripting language.", "cat": "CS"},
  {"term": "Linked List", "def": "A linear collection of data elements.", "cat": "CS"},
  {"term": "Loop", "def": "A sequence of instructions that is continually repeated until a certain condition is reached.", "cat": "CS"},
  {"term": "Memory", "def": "The faculty of the brain by which data or information is encoded, stored, and retrieved when needed.", "cat": "CS"},
  {"term": "Multithreading", "def": "The ability of a central processing unit (CPU) to provide multiple threads of execution concurrently.", "cat": "CS"},
  {"term": "Object", "def": "An abstract data type.", "cat": "CS"},
  {"term": "OOP", "def": "Object-Oriented Programming.", "cat": "CS"},
  {"term": "Operating System", "def": "System software that manages computer hardware, software resources, and provides common services for computer programs.", "cat": "CS"},
  {"term": "Pointer", "def": "A programming language object that stores the memory address of another value.", "cat": "CS"},
  {"term": "Polymorphism", "def": "The provision of a single interface to entities of different types.", "cat": "CS"},
  {"term": "Queue", "def": "A collection of entities that are maintained in a sequence.", "cat": "CS"},
  {"term": "Recursion", "def": "A method of solving a problem where the solution depends on solutions to smaller instances of the same problem.", "cat": "CS"},
  {"term": "Sorting", "def": "Any process of arranging items systematically.", "cat": "CS"},
  {"term": "Stack", "def": "A linear data structure which follows a particular order in which the operations are performed.", "cat": "CS"},
  {"term": "String", "def": "A sequence of characters.", "cat": "CS"},
  {"term": "Tree", "def": "A widely used abstract data type that simulates a hierarchical tree structure.", "cat": "CS"},
  {"term": "Variable", "def": "A storage location paired with an associated symbolic name.", "cat": "CS"}
];
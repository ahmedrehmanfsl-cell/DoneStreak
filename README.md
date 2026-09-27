DoneStreak

Turn real-life consistency into a habit the way social media already trained you to.

DoneStreak applies the same "streak" psychology that makes Snapchat addictive to real personal goals. Instead of sending a snap to a friend, you send yourself a quick daily proof photo for the commitments that matter — gym, studying, reading, cutting out junk food. Miss a day, the streak breaks. Simple, visual, and genuinely motivating.

✨ Features

📸 Camera-first UI — opens straight into proof capture, no cluttered dashboard

🟠 Custom animated "streak orb" — a fully original growing/glowing visual instead of a generic progress bar

✅ Add, edit & delete personal commitments with custom icons

🖼️ Memory Reel — a visual collage of your past proof photos per commitment, Snapchat-Memories style

🔒 100% offline & private — no login, no backend, no internet dependency

🚫 Zero third-party SDKs — no analytics, ads, tracking, or crash-reporting libraries anywhere in the app

🛠️ Tech Stack
	
Framework	Flutter (Dart)

Storage	shared_preferences (local key-value) — no cloud, no server

Camera	image_picker (native device camera)

Platforms	iOS & Android from a single codebase


No Firebase, no REST APIs, no third-party analytics — everything runs entirely on-device.


📂 Project Structure
lib/

 ├─ main.dart
 
 ├─ models/
 
 │   └─ commitment.dart          # data model
 
 ├─ services/
 
 │   └─ storage_service.dart     # local persistence
 
 ├─ screens/
 
 │   ├─ home_screen.dart         # camera-first main screen
 
 │   ├─ add_commitment_screen.dart
 
 │   └─ memory_reel_screen.dart
 
 └─ widgets/
 
     ├─ commitment_card.dart
	 
     └─ streak_orb.dart          # custom-painted animated orb
	 
assets/

 └─ icon/app_icon.png
 
🚀 Getting Started

bash

git clone https://github.com/YOUR_USERNAME/donestreak.git

cd donestreak

flutter create --org com.yourcompany --platforms=ios,android .

flutter pub get

flutter run


Note: ios/ and android/ platform folders are generated locally via flutter create and are excluded from version control — see .gitignore.

Privacy

DoneStreak collects nothing. No account, no analytics, no network calls. All photos and streak data stay on the user's device only.

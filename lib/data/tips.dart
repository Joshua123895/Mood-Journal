import 'dart:math';
import 'dart:ui';

class StatsCardVariation {
  final String topAsset;
  final String faceAsset;
  final Color jarColor;
  final String title;
  final String body;

  const StatsCardVariation({
    required this.topAsset,
    required this.faceAsset,
    required this.jarColor,
    required this.title,
    required this.body,
  });
}

class StatsCardVariationManager {
  StatsCardVariationManager._();

  static final Random _random = Random();

  static const Map<String, List<StatsCardVariation>> _groups = {
    'low': [
      StatsCardVariation(
        topAsset: 'rain.svg',
        faceAsset: 'sad.svg',
        jarColor: Color(0xFF567CBF),
        title: "It's okay to not be okay.",
        body: "Give yourself grace and rest when you need it.",
      ),
      StatsCardVariation(
        topAsset: 'heart.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF567CBF),
        title: "One step is enough today.",
        body: "Small progress is still progress.",
      ),
      StatsCardVariation(
        topAsset: 'cloud_blue.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF567CBF),
        title: "You've survived every hard day so far.",
        body: "Today is no different.",
      ),
      StatsCardVariation(
        topAsset: 'heart.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF567CBF),
        title: "Be gentle with yourself.",
        body: "Healing isn't a race.",
      ),
      StatsCardVariation(
        topAsset: 'cloud_blue.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF567CBF),
        title: "Feelings are visitors.",
        body: "They come and go with time.",
      ),
      StatsCardVariation(
        topAsset: 'star.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF567CBF),
        title: "Rest without guilt.",
        body: "Your worth isn't measured by productivity.",
      ),
      StatsCardVariation(
        topAsset: 'cloud_blue.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF567CBF),
        title: "Today can be a slow day.",
        body: "That's perfectly fine.",
      ),
      StatsCardVariation(
        topAsset: 'star.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF567CBF),
        title: "You don't need all the answers.",
        body: "Focus on the next step.",
      ),
      StatsCardVariation(
        topAsset: 'wind.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF567CBF),
        title: "Take things one breath at a time.",
        body: "The future can wait.",
      ),
      StatsCardVariation(
        topAsset: 'heart.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF567CBF),
        title: "Some days are for surviving.",
        body: "And that's enough.",
      ),
    ],

    'neutral': [
      StatsCardVariation(
        topAsset: 'questions.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF9BC8A9),
        title: "Check in with yourself.",
        body: "What do you need right now?",
      ),
      StatsCardVariation(
        topAsset: 'balance.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF9BC8A9),
        title: "Balance is important.",
        body: "Work and rest belong together.",
      ),
      StatsCardVariation(
        topAsset: 'think_heart.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF9BC8A9),
        title: "Notice the little things.",
        body: "Small joys often matter most.",
      ),
      StatsCardVariation(
        topAsset: 'leaf_green.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF9BC8A9),
        title: "Progress isn't always obvious.",
        body: "Keep moving forward.",
      ),
      StatsCardVariation(
        topAsset: 'think_question.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF9BC8A9),
        title: "Stay curious today.",
        body: "You might surprise yourself.",
      ),
      StatsCardVariation(
        topAsset: 'cloud_green.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF9BC8A9),
        title: "Every day teaches something.",
        body: "Pay attention.",
      ),
      StatsCardVariation(
        topAsset: 'heart.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF9BC8A9),
        title: "You're doing better than you think.",
        body: "Give yourself more credit.",
      ),
      StatsCardVariation(
        topAsset: 'cloud_restart.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF9BC8A9),
        title: "It's okay to change your mind.",
        body: "Growth means flexibility.",
      ),
      StatsCardVariation(
        topAsset: 'leaf_green.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF9BC8A9),
        title: "Focus on what you can control.",
        body: "Let go of the rest.",
      ),
      StatsCardVariation(
        topAsset: 'cloud_green.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF9BC8A9),
        title: "You don't have to have it all figured out.",
        body: "And that's okay.",
      ),
    ],

    'good': [
      StatsCardVariation(
        topAsset: 'star_yellow.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFFFEB73D),
        title: "You're doing better than you think.",
        body: "Celebrate the small wins.",
      ),
      StatsCardVariation(
        topAsset: 'heart.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFFFEB73D),
        title: "Protect this energy.",
        body: "Keep doing what helps you feel good.",
      ),
      StatsCardVariation(
        topAsset: 'plus.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFFFEB73D),
        title: "Positive moments matter.",
        body: "Save this feeling in your journal.",
      ),
      StatsCardVariation(
        topAsset: 'leaf_yellow.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFFFEB73D),
        title: "Growth isn't always dramatic.",
        body: "Quiet progress is still progress.",
      ),
      StatsCardVariation(
        topAsset: 'say_heart.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFFFEB73D),
        title: "Share your positivity.",
        body: "A kind word can brighten someone's day.",
      ),
      StatsCardVariation(
        topAsset: 'star.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFFFEB73D),
        title: "You're building a better you.",
        body: "And it shows.",
      ),
      StatsCardVariation(
        topAsset: 'sunrise.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFFFEB73D),
        title: "Keep going.",
        body: "You're on the right path.",
      ),
      StatsCardVariation(
        topAsset: 'star_yellow.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFFFEB73D),
        title: "Enjoy the little victories.",
        body: "They're proof you're moving forward.",
      ),
      StatsCardVariation(
        topAsset: 'say_heart.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFFFEB73D),
        title: "Let yourself feel proud.",
        body: "You deserve it.",
      ),
      StatsCardVariation(
        topAsset: 'star_yellow.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFFFEB73D),
        title: "Good things happen when you keep showing up.",
        body: "Keep showing up.",
      ),
    ],

    'excellent': [
      StatsCardVariation(
        topAsset: 'star_pink.svg',
        faceAsset: 'blush.svg',
        jarColor: Color(0xFFF4B1C4),
        title: "Look how far you've come.",
        body: "Take pride in your journey.",
      ),
      StatsCardVariation(
        topAsset: 'heart.svg',
        faceAsset: 'blush.svg',
        jarColor: Color(0xFFF4B1C4),
        title: "Enjoy this moment fully.",
        body: "You don't always need the next goal.",
      ),
      StatsCardVariation(
        topAsset: 'photo_star.svg',
        faceAsset: 'blush.svg',
        jarColor: Color(0xFFF4B1C4),
        title: "Capture what's working.",
        body: "Future you will be grateful.",
      ),
      StatsCardVariation(
        topAsset: 'heart_star.svg',
        faceAsset: 'blush.svg',
        jarColor: Color(0xFFF4B1C4),
        title: "Good energy is contagious.",
        body: "Spread a little kindness.",
      ),
      StatsCardVariation(
        topAsset: 'confetti.svg',
        faceAsset: 'blush.svg',
        jarColor: Color(0xFFF4B1C4),
        title: "Celebrate yourself.",
        body: "You earned this moment.",
      ),
      StatsCardVariation(
        topAsset: 'heart.svg',
        faceAsset: 'blush.svg',
        jarColor: Color(0xFFF4B1C4),
        title: "Keep being you.",
        body: "You're doing amazing.",
      ),
      StatsCardVariation(
        topAsset: 'dream.svg',
        faceAsset: 'blush.svg',
        jarColor: Color(0xFFF4B1C4),
        title: "Dream bigger but enjoy now.",
        body: "Have both.",
      ),
      StatsCardVariation(
        topAsset: 'star_pink.svg',
        faceAsset: 'blush.svg',
        jarColor: Color(0xFFF4B1C4),
        title: "Savor the good days.",
        body: "They're part of your story.",
      ),
      StatsCardVariation(
        topAsset: 'heart_star.svg',
        faceAsset: 'blush.svg',
        jarColor: Color(0xFFF4B1C4),
        title: "Your vibes today matter.",
        body: "Keep shining.",
      ),
      StatsCardVariation(
        topAsset: 'heart.svg',
        faceAsset: 'blush.svg',
        jarColor: Color(0xFFF4B1C4),
        title: "You're inspiring your future self.",
        body: "Keep it up.",
      ),
    ],

    'improving': [
      StatsCardVariation(
        topAsset: 'up.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF567CBF),
        title: "You're moving in the right direction.",
        body: "Progress doesn't need to be perfect.",
      ),
      StatsCardVariation(
        topAsset: 'up.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF567CBF),
        title: "Notice the change.",
        body: "The little improvements add up.",
      ),
      StatsCardVariation(
        topAsset: 'up.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF567CBF),
        title: "Keep nurturing what helps.",
        body: "Your habits are making a difference.",
      ),
    ],

    'declining': [
      StatsCardVariation(
        topAsset: 'down.svg',
        faceAsset: 'sad.svg',
        jarColor: Color(0xFF896DAD),
        title: "A rough patch isn't a failure.",
        body: "Be curious about what you need right now.",
      ),
      StatsCardVariation(
        topAsset: 'heart.svg',
        faceAsset: 'sad.svg',
        jarColor: Color(0xFF896DAD),
        title: "Listen to your mind and body.",
        body: "They ask for rest before action.",
      ),
      StatsCardVariation(
        topAsset: 'sleep.svg',
        faceAsset: 'sad.svg',
        jarColor: Color(0xFF896DAD),
        title: "You don't have to carry everything alone.",
        body: "Reach out if you need support.",
      ),
    ],

    'streakRewards': [
      StatsCardVariation(
        topAsset: 'fire_red.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFFEAA98D),
        title: "3-Day Streak!",
        body: "Building awareness starts with showing up.",
      ),
      StatsCardVariation(
        topAsset: 'fire_yellow.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFFEAA98D),
        title: "7-Day Streak!",
        body: "Your consistency is becoming a habit.",
      ),
      StatsCardVariation(
        topAsset: 'fire_blue.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFFEAA98D),
        title: "30-Day Streak!",
        body: "Look back and see how much you've documented.",
      ),
      StatsCardVariation(
        topAsset: 'fire_purple.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFFEAA98D),
        title: "100-Day Streak!",
        body: "Amazing commitment. You should be proud!",
      ),
    ],

    'morning': [
      StatsCardVariation(
        topAsset: 'sunrise.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFFFEB73D),
        title: "Good morning.",
        body: "What intention would you like to set for today?",
      ),
      StatsCardVariation(
        topAsset: 'sunrise.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFFFEB73D),
        title: "A new day starts now.",
        body: "Focus on one thing you can control.",
      ),
      StatsCardVariation(
        topAsset: 'sunrise.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFFFEB73D),
        title: "Today is a fresh start.",
        body: "Make it meaningful.",
      ),
    ],

    'afternoon': [
      StatsCardVariation(
        topAsset: 'sun.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF9BC8A9),
        title: "How's your day going?",
        body: "Take a quick pause and check in.",
      ),
      StatsCardVariation(
        topAsset: 'sun.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF9BC8A9),
        title: "You've got this.",
        body: "Keep going, one step at a time.",
      ),
      StatsCardVariation(
        topAsset: 'sun.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF9BC8A9),
        title: "Halfway through the day.",
        body: "There's still time to make it count.",
      ),
    ],

    'night': [
      StatsCardVariation(
        topAsset: 'moon.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF567CBF),
        title: "The day is ending.",
        body: "Reflect on one thing that went well.",
      ),
      StatsCardVariation(
        topAsset: 'moon.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF567CBF),
        title: "You made it through today.",
        body: "Rest is part of growth.",
      ),
      StatsCardVariation(
        topAsset: 'moon.svg',
        faceAsset: 'happy.svg',
        jarColor: Color(0xFF567CBF),
        title: "Let go of what you can't control.",
        body: "Sleep, reset, and try again tomorrow.",
      ),
    ],
  };

  static StatsCardVariation getVariation(String type) {
    final variations = _groups[type];
    if (variations == null || variations.isEmpty) {
      throw ArgumentError('No variations found for type: $type');
    }
    return variations[_random.nextInt(variations.length)];
  }
}

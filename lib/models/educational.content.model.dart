enum ContentType { article, video, guide }

class EducationalContent {
  final String title;
  final String description;
  final ContentType type; // Changed to ContentType
  final String contentUrl; // URL for video or link for articles

  EducationalContent({
    required this.title,
    required this.description,
    required this.type,
    required this.contentUrl,
  });
}

const dummyUrl =
    "https://firebasestorage.googleapis.com/v0/b/kavinda-f44d7.appspot.com/o/utomp3.com%20-%20How%20to%20TAKE%20CARE%20of%20a%20PUPPY%20%20Complete%20Guide%20to%20Puppy%20Care_v240P.mp4?alt=media&token=a2e8314c-61ba-4ea2-817d-10dbcbb3b5bb";

// Sample Educational Content List
List<EducationalContent> educationalContentList = [
  EducationalContent(
    title: "Understanding Dog Nutrition",
    description: "An in-depth look at dog nutrition and dietary needs.",
    type: ContentType.article, // Use ContentType enum
    contentUrl: "https://example.com/nutrition",
  ),
  EducationalContent(
    title: "Healthy Treats for Dogs",
    description: "Discover the best treats for your furry friend.",
    type: ContentType.article, // Use ContentType enum
    contentUrl: "https://example.com/treats",
  ),
  EducationalContent(
    title: "Dog Breeds and Their Needs",
    description: "A guide to various dog breeds and their specific needs.",
    type: ContentType.guide, // Use ContentType enum
    contentUrl: "https://example.com/breeds",
  ),
  EducationalContent(
    title: "Dog Nutrition Basics",
    description: "Video guide on dog nutrition basics.",
    type: ContentType.video, // Use ContentType enum
    contentUrl: dummyUrl, // Use dummyUrl for video
  ),
];

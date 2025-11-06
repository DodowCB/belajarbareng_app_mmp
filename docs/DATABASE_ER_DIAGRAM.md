# 🗂️ DATABASE ENTITY RELATIONSHIP DIAGRAM

## 📊 Complete ER Diagram

```
┌─────────────────────────────────────────────────────────────────────────────────┐
│                        BELAJARBARENG APP - DATABASE SCHEMA                      │
└─────────────────────────────────────────────────────────────────────────────────┘

┌──────────────────┐
│     USERS        │
├──────────────────┤
│ PK userId        │
│    email         │──┐
│    displayName   │  │
│    photoUrl      │  │
│    createdAt     │  │
│    updatedAt     │  │  Creates
│    joinedGroups[]│  │
│    preferences{} │  ├────────────┐
│    stats{}       │  │            │
│    badges[]      │  │            ▼
│    subscription{}│  │  ┌──────────────────┐
└──────────────────┘  │  │  STUDY_GROUPS    │
         │            │  ├──────────────────┤
         │ Creates    │  │ PK groupId       │
         │            │  │    name          │
         ▼            │  │    description   │
┌──────────────────┐  │  │    category      │
│ LEARNING_        │  │  │ FK creatorId     │──┐
│ MATERIALS        │  │  │    members[]     │  │
├──────────────────┤  │  │    maxMembers    │  │
│ PK materialId    │  │  │    createdAt     │  │
│    title         │  │  │    updatedAt     │  │
│    description   │  │  │    isPublic      │  │
│    category      │  │  │    imageUrl      │  │
│    type          │  │  │    settings{}    │  │
│    url           │  │  │    stats{}       │  │
│    thumbnailUrl  │  │  │    tags[]        │  │
│ FK creatorId     │◄─┘  └──────────────────┘  │
│    createdAt     │              │            │
│    updatedAt     │              │ Has        │
│    tags[]        │              ▼            │
│    difficulty    │     ┌──────────────────┐  │
│    estimatedDur  │     │  GROUP_POSTS     │  │
│    metadata{}    │     ├──────────────────┤  │
│    isPublished   │     │ PK postId        │  │
│    isPremium     │     │ FK groupId       │  │
│ FK groupId       │     │ FK authorId      │  │
│    relatedMat[]  │     │    type          │  │
└──────────────────┘     │    title         │  │
         │               │    content       │  │
         │ Tracks        │    attachments[] │  │
         ▼               │ FK materialId    │  │
┌──────────────────┐     │    createdAt     │  │
│  USER_PROGRESS   │     │    updatedAt     │  │
├──────────────────┤     │    likeCount     │  │
│ PK progressId    │     │    commentCount  │  │
│ FK userId        │     │    isPinned      │  │
│ FK materialId    │     └──────────────────┘  │
│    progress      │                           │
│    lastUpdated   │                           │
│    completedAt   │                           │
│    startedAt     │                           │
│    timeSpent     │     ┌──────────────────┐  │
│    additionalData│     │  QNA_QUESTIONS   │  │
│    notes         │     ├──────────────────┤  │
│    rating        │     │ PK questionId    │  │
│    isFavorite    │     │    title         │  │
└──────────────────┘     │    content       │  │
                         │    category      │  │
┌──────────────────┐     │    tags[]        │  │
│     QUIZZES      │     │ FK authorId      │◄─┘
├──────────────────┤     │    createdAt     │
│ PK quizId        │     │    updatedAt     │
│    title         │     │    viewCount     │
│    description   │     │    upvotes       │
│    category      │     │    downvotes     │
│ FK creatorId     │◄─┐  │    answerCount   │
│    createdAt     │  │  │    hasAccepted   │
│    updatedAt     │  │  │ FK acceptedAnsId │
│    difficulty    │  │  │    isClosed      │
│    estimatedDur  │  │  │    closedReason  │
│    totalQuestions│  │  │    attachments[] │
│    passingScore  │  │  │    relatedQs[]   │
│    questions[]   │  │  └──────────────────┘
│    tags[]        │  │           │
│    isPublished   │  │           │ Has
│ FK materialId    │  │           ▼
└──────────────────┘  │  ┌──────────────────┐
         │            │  │   QNA_ANSWERS    │
         │ Has        │  ├──────────────────┤
         ▼            │  │ PK answerId      │
┌──────────────────┐  │  │ FK questionId    │
│  QUIZ_ATTEMPTS   │  │  │    content       │
├──────────────────┤  │  │ FK authorId      │◄─┘
│ PK attemptId     │  │  │    createdAt     │
│ FK userId        │◄─┘  │    updatedAt     │
│ FK quizId        │     │    upvotes       │
│    startedAt     │     │    downvotes     │
│    completedAt   │     │    isAccepted    │
│    score         │     │    attachments[] │
│    correctAnswers│     │    codeSnippets[]│
│    totalQuestions│     └──────────────────┘
│    timeSpent     │              │
│    answers[]     │              │
│    isPassed      │              ▼
└──────────────────┘     ┌──────────────────┐
                         │    COMMENTS      │
┌──────────────────┐     ├──────────────────┤
│  NOTIFICATIONS   │     │ PK commentId     │
├──────────────────┤     │    parentType    │
│ PK notificationId│     │ FK parentId      │
│ FK userId        │◄─┐  │    content       │
│    type          │  │  │ FK authorId      │◄─┐
│    title         │  │  │    createdAt     │  │
│    message       │  │  │    updatedAt     │  │
│    data{}        │  │  │    upvotes       │  │
│    imageUrl      │  │  │    downvotes     │  │
│    isRead        │  │  │    replyCount    │  │
│    createdAt     │  │  │    isEdited      │  │
│    expiresAt     │  │  │    isDeleted     │  │
└──────────────────┘  │  └──────────────────┘  │
                      │                        │
┌──────────────────┐  │  ┌──────────────────┐  │
│     BADGES       │  │  │   USER_BADGES    │  │
├──────────────────┤  │  ├──────────────────┤  │
│ PK badgeId       │  │  │ PK userBadgeId   │  │
│    name          │  │  │ FK userId        │──┘
│    description   │  │  │ FK badgeId       │
│    imageUrl      │  │  │    earnedAt      │
│    category      │  │  │    progress      │
│    criteria{}    │  │  └──────────────────┘
│    points        │  │
│    rarity        │  │  ┌──────────────────┐
└──────────────────┘  │  │   LEADERBOARD    │
         │            │  ├──────────────────┤
         │ Awards     │  │ PK leaderboardId │
         └────────────┼─►│ FK userId        │
                      │  │    displayName   │
                      │  │    photoUrl      │
                      │  │    totalPoints   │
                      │  │    level         │
                      │  │    rank          │
                      │  │    weeklyPoints  │
                      │  │    monthlyPoints │
                      │  │    stats{}       │
                      │  │    updatedAt     │
                      └─►└──────────────────┘

═══════════════════════════════════════════════════════════════════════════

LEGEND:
├─────┤  Table
│ PK  │  Primary Key
│ FK  │  Foreign Key
│ []  │  Array field
│ {}  │  Object/Map field
  │     One-to-Many relationship
  ▼     Relationship direction
```

---

## 🔗 Relationship Details

### **1. Users → Learning Materials (1:N)**

- One user can create many materials
- Field: `learning_materials.creatorId` references `users.userId`

### **2. Users → Study Groups (1:N - as creator)**

- One user can create many groups
- Field: `study_groups.creatorId` references `users.userId`

### **3. Users ↔ Study Groups (M:N - as member)**

- Many users can join many groups
- Field: `study_groups.members[]` contains array of `userId`
- Field: `users.joinedGroups[]` contains array of `groupId`

### **4. Users → User Progress (1:N)**

- One user has many progress records
- Field: `user_progress.userId` references `users.userId`

### **5. Learning Materials → User Progress (1:N)**

- One material tracked by many users
- Field: `user_progress.materialId` references `learning_materials.materialId`

### **6. Users → Quizzes (1:N)**

- One user can create many quizzes
- Field: `quizzes.creatorId` references `users.userId`

### **7. Users → Quiz Attempts (1:N)**

- One user can have many quiz attempts
- Field: `quiz_attempts.userId` references `users.userId`

### **8. Quizzes → Quiz Attempts (1:N)**

- One quiz can have many attempts
- Field: `quiz_attempts.quizId` references `quizzes.quizId`

### **9. Study Groups → Group Posts (1:N)**

- One group has many posts
- Field: `group_posts.groupId` references `study_groups.groupId`

### **10. Users → Q&A Questions (1:N)**

- One user can ask many questions
- Field: `qna_questions.authorId` references `users.userId`

### **11. Q&A Questions → Q&A Answers (1:N)**

- One question can have many answers
- Field: `qna_answers.questionId` references `qna_questions.questionId`

### **12. Users → Q&A Answers (1:N)**

- One user can post many answers
- Field: `qna_answers.authorId` references `users.userId`

### **13. Users → Comments (1:N)**

- One user can post many comments
- Field: `comments.authorId` references `users.userId`

### **14. Polymorphic: Materials/Questions/Answers → Comments (1:N)**

- Comments can belong to materials, questions, or answers
- Fields: `comments.parentType` + `comments.parentId`

### **15. Users → Notifications (1:N)**

- One user can have many notifications
- Field: `notifications.userId` references `users.userId`

### **16. Badges → User Badges (1:N)**

- One badge can be earned by many users
- Field: `user_badges.badgeId` references `badges.badgeId`

### **17. Users → User Badges (1:N)**

- One user can earn many badges
- Field: `user_badges.userId` references `users.userId`

### **18. Users → Leaderboard (1:1)**

- One user has one leaderboard entry
- Field: `leaderboard.userId` references `users.userId` (Unique)

---

## 📋 Cardinality Summary

```
RELATIONSHIP                              TYPE      CARDINALITY
──────────────────────────────────────────────────────────────
Users → Learning Materials                1:N       One-to-Many
Users → Study Groups (creator)            1:N       One-to-Many
Users ↔ Study Groups (member)             M:N       Many-to-Many
Users → User Progress                     1:N       One-to-Many
Learning Materials → User Progress        1:N       One-to-Many
Users → Quizzes                           1:N       One-to-Many
Quizzes → Quiz Attempts                   1:N       One-to-Many
Users → Quiz Attempts                     1:N       One-to-Many
Study Groups → Group Posts                1:N       One-to-Many
Users → Group Posts                       1:N       One-to-Many
Users → QnA Questions                     1:N       One-to-Many
QnA Questions → QnA Answers               1:N       One-to-Many
Users → QnA Answers                       1:N       One-to-Many
Users → Comments                          1:N       One-to-Many
(Polymorphic) → Comments                  1:N       One-to-Many
Users → Notifications                     1:N       One-to-Many
Badges → User Badges                      1:N       One-to-Many
Users → User Badges                       1:N       One-to-Many
Users → Leaderboard                       1:1       One-to-One
Learning Materials → Quizzes              1:N       One-to-Many
Study Groups → Learning Materials         1:N       One-to-Many
```

---

## 🎨 Visual Hierarchy

```
┌─────────────┐
│    USERS    │ ← Core entity
└─────────────┘
      │
      ├─── Creates ──→ Learning Materials
      │                      │
      │                      └─── Tracked by → User Progress
      │
      ├─── Creates ──→ Study Groups
      │                      │
      │                      └─── Contains → Group Posts
      │
      ├─── Creates ──→ Quizzes
      │                      │
      │                      └─── Taken in → Quiz Attempts
      │
      ├─── Asks ──→ QnA Questions
      │                   │
      │                   └─── Answered by → QnA Answers
      │
      ├─── Posts ──→ Comments
      │
      ├─── Receives ──→ Notifications
      │
      ├─── Earns ──→ User Badges ←── Defined in → Badges
      │
      └─── Ranked in ──→ Leaderboard
```

---

## 🗄️ Collection Size Estimates

| Collection             | Est. Docs/User | Growth Rate | Priority |
| ---------------------- | -------------- | ----------- | -------- |
| **users**              | 1              | Low         | Critical |
| **learning_materials** | 10-20          | Medium      | Critical |
| **study_groups**       | 3-5            | Low         | High     |
| **user_progress**      | 15-30          | High        | Critical |
| **quizzes**            | 5-10           | Medium      | Medium   |
| **quiz_attempts**      | 20-40          | High        | Medium   |
| **qna_questions**      | 5-15           | Medium      | High     |
| **qna_answers**        | 15-45          | High        | High     |
| **comments**           | 30-100         | Very High   | Medium   |
| **notifications**      | 50-200         | Very High   | Low      |
| **badges**             | Fixed (~50)    | None        | Low      |
| **user_badges**        | 10-30          | Medium      | Low      |
| **leaderboard**        | 1              | Low         | Low      |
| **group_posts**        | 10-30          | Medium      | Medium   |

---

## 📊 Data Access Patterns

### **Most Frequent Queries**

1. **Get user dashboard data**

   - user → progress (filter: userId)
   - user → materials (filter: category)
   - user → study_groups (filter: userId in members)

2. **Browse materials**

   - materials (filter: category, difficulty)
   - materials (orderBy: createdAt, limit: 20)

3. **View group**

   - study_groups (doc: groupId)
   - group_posts (filter: groupId, orderBy: createdAt)

4. **Q&A Forum**

   - qna_questions (filter: category, orderBy: createdAt)
   - qna_answers (filter: questionId, orderBy: upvotes)

5. **Progress tracking**
   - user_progress (filter: userId, materialId)
   - user_progress (filter: userId, orderBy: lastUpdated)

---

**Status**: ✅ ER Diagram Complete  
**Last Updated**: November 4, 2025  
**References**:

- [Database Design](./DATABASE_DESIGN.md)
- [Connection Guide](./DATABASE_CONNECTION.md)

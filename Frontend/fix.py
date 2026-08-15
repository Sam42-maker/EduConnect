import re

filepath = r"D:\EduConnect\Frontend\lib\screens\home_screen.dart"
with open(filepath, "r", encoding="utf-8") as f:
    content = f.read()

# 1. Add context to method calls in build()
content = content.replace("_buildNewsSection()", "_buildNewsSection(context)")
content = content.replace("_buildRecommendedList()", "_buildRecommendedList(context)")
content = content.replace("_buildActiveNowList()", "_buildActiveNowList(context)")
content = content.replace("_buildQuickActions()", "_buildQuickActions(context)")
content = content.replace("_buildCommunitiesList()", "_buildCommunitiesList(context)")

# 2. Add BuildContext context to method signatures
content = content.replace("Widget _buildNewsSection() {", "Widget _buildNewsSection(BuildContext context) {")
content = content.replace("Widget _buildRecommendedList() {", "Widget _buildRecommendedList(BuildContext context) {")
content = content.replace("Widget _buildActiveNowList() {", "Widget _buildActiveNowList(BuildContext context) {")
content = content.replace("Widget _buildQuickActions() {", "Widget _buildQuickActions(BuildContext context) {")
content = content.replace("Widget _buildCommunitiesList() {", "Widget _buildCommunitiesList(BuildContext context) {")

# 3. Fix missing closing brackets for GestureDetector
# In _buildNewsCard
content = re.sub(r'(maxLines: 3,\s*overflow: TextOverflow\.ellipsis,\s*\),\s*\],\s*\),\s*)\);', r'\1),\n    );', content)

# In _buildMatchCard
content = re.sub(r'(Text\(\s*lastActive,\s*style: const TextStyle\(color: Colors\.black38, fontSize: 10\),\s*\),\s*\],\s*\),\s*\],\s*\),\s*)\);', r'\1),\n    );', content)

# In _buildActiveNowList
# I had: 
# children: actives.map((e) => GestureDetector(onTap: ..., child: Column(...)))
# But I didn't close GestureDetector properly!
# Let's fix this manually with a regex that finds the end of the Column
content = re.sub(
    r"(style:\s*const\s*TextStyle\(\s*fontSize:\s*9,\s*color:\s*Colors\.black38,\s*\),\s*\),\s*\],\s*\)\s*)\)\s*\.toList\(\),",
    r"\1),\n                  )\n                .toList(),",
    content
)

# In _buildActionCard
content = re.sub(r'(maxLines: 2,\s*overflow: TextOverflow\.ellipsis,\s*\),\s*\],\s*\),\s*)\);', r'\1),\n    );', content)

# In _buildCommunityCard
content = re.sub(r'(style:\s*const\s*TextStyle\(fontSize:\s*11,\s*color:\s*Colors\.black54\),\s*\),\s*\],\s*\),\s*\],\s*\),\s*)\);', r'\1),\n    );', content)


with open(filepath, "w", encoding="utf-8") as f:
    f.write(content)
print("Fixed!")

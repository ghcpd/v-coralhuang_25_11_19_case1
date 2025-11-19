# Product Browser - Modern Search & Filter UI

A modern, responsive product browsing interface with real-time search, category filtering, price sorting, and elegant UI/UX design.

## 🌟 Features

### Core Functionality
- **Product Grid Display**: Responsive card-based layout with 12 sample products
- **Real-time Search**: Instant filtering by product name or description
- **Category Filter**: Filter by Electronics, Photography, Audio, Computing
- **Price Sorting**: Sort products by price (low to high, high to low)
- **Loading States**: Smooth loading animations when applying filters
- **Empty States**: Friendly messages when no products match filters
- **Responsive Design**: Mobile-first approach, works on all screen sizes

### UI/UX Highlights
- Clean, modern design with Tailwind CSS
- Smooth hover animations and transitions
- Accessible form elements with proper labels
- Professional typography and spacing
- Visual badges (Best Seller, New, Popular)
- Results counter showing filtered product count

## 🚀 Quick Start

### Prerequisites
- **Python 3.x** - For running the development server
- **Windows**: Use `.bat` scripts
- **Linux/macOS**: Use `.sh` scripts

### Running the Application

#### On Windows:
```batch
# 1. Verify dependencies
setup.bat

# 2. Start the development server
run.bat
```

#### On Linux/macOS:
```bash
# 1. Make scripts executable
chmod +x setup.sh run.sh test.sh

# 2. Verify dependencies
./setup.sh

# 3. Start the development server
./run.sh
```

The application will be available at: **http://localhost:3000**

## 🧪 Testing

### Automated Tests

The project includes comprehensive automated tests that verify:
- Dependency installation
- Server startup and HTTP responses
- Presence of all UI elements
- JavaScript functionality
- CSS framework loading

#### Run Tests on Windows:
```batch
test.bat
```

#### Run Tests on Linux/macOS:
```bash
./test.sh
```

### Test Coverage
- ✓ Python 3 installation
- ✓ index.html existence
- ✓ HTTP 200 response
- ✓ Search input presence
- ✓ Category filter presence
- ✓ Sort dropdown presence
- ✓ Products container presence
- ✓ Loading state element
- ✓ Empty state element
- ✓ Product data initialization
- ✓ Tailwind CSS loading

## 🐳 Docker

### Build and Run with Docker

```bash
# Build the Docker image
docker build -t product-browser .

# Run the container (executes tests automatically)
docker run --rm product-browser

# Run the container with server (for manual testing)
docker run --rm -p 3000:3000 product-browser ./run.sh
```

The Dockerfile creates a reproducible environment that:
- Installs Python 3.11
- Installs required tools (curl, bash)
- Runs automated tests by default
- Exposes port 3000 for the web server

## 📁 Project Structure

```
.
├── index.html          # Main application file (HTML, CSS, JavaScript)
├── input.html          # Original broken file (kept for reference)
├── setup.sh            # Bash setup script (Linux/macOS)
├── setup.bat           # Batch setup script (Windows)
├── run.sh              # Bash run script (Linux/macOS)
├── run.bat             # Batch run script (Windows)
├── test.sh             # Bash test script (Linux/macOS)
├── test.bat            # Batch test script (Windows)
├── Dockerfile          # Docker containerization
└── README.md           # This file
```

## 🎨 UI Components

### Header
- Application title and description
- Clean, professional styling with shadow

### Filter Controls
- **Search Input**: Real-time text filtering
- **Category Dropdown**: Filter by product category
- **Sort Dropdown**: Sort by price (ascending/descending)
- **Results Counter**: Shows number of filtered products

### Product Cards
Each product card displays:
- Product name
- Price (formatted with currency)
- Description
- Category badge
- Optional promotional badge (Best Seller, New, Popular)
- View Details button with hover effect
- Smooth card elevation on hover

### Loading State
- Animated spinner
- Loading message
- Appears during filter operations (300ms simulated delay)

### Empty State
- Large search icon
- Helpful message
- Reset filters button
- Clean, centered design

## 🛠️ Technology Stack

- **HTML5**: Semantic markup
- **CSS3**: Custom animations and transitions
- **Tailwind CSS**: Utility-first styling framework (CDN)
- **Vanilla JavaScript**: No framework dependencies
- **Python**: Built-in HTTP server for development
- **Docker**: Containerized deployment

## 💡 Implementation Details

### Product Data
The application includes 12 sample products across 4 categories:
- Computing (4 products)
- Electronics (2 products)
- Photography (3 products)
- Audio (3 products)

Price range: $149 - $1,899

### Filter Logic
1. **Search**: Case-insensitive text matching on name and description
2. **Category**: Exact match filtering
3. **Sort**: JavaScript array sorting by price property
4. **Combination**: All filters work together seamlessly

### Performance
- Simulated 300ms loading delay for better UX
- Efficient DOM manipulation
- Smooth CSS transitions
- Responsive event listeners

## 🔧 Customization

### Adding Products
Edit the `productsData` array in `index.html`:

```javascript
const productsData = [
  {
    id: 13,
    name: "Your Product Name",
    price: 999,
    category: "Electronics",
    description: "Product description here",
    badge: "New" // Optional: "Best Seller", "New", "Popular", or ""
  }
];
```

### Adding Categories
Update the category dropdown in `index.html`:

```html
<option value="YourCategory">Your Category</option>
```

### Styling
The project uses Tailwind CSS. Modify classes in `index.html` or add custom CSS in the `<style>` section.

## 📊 Browser Support

- ✓ Chrome/Edge (latest)
- ✓ Firefox (latest)
- ✓ Safari (latest)
- ✓ Mobile browsers

## 🤝 Contributing

This is a demonstration project. Feel free to fork and customize for your needs.

## 📝 License

This project is provided as-is for educational and demonstration purposes.

## 🎯 Project Goals

This project demonstrates:
- Modern web development practices
- Responsive design principles
- User-friendly UI/UX
- Automated testing
- Cross-platform compatibility
- Docker containerization
- One-click deployment

---

**Built with ❤️ using modern web standards**

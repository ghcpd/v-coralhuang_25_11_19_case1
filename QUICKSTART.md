# Quick Start Guide

## ⚡ For Windows Users

```batch
# 1. Run setup
setup.bat

# 2. Start server
run.bat

# 3. Open browser to http://localhost:3000

# 4. Run tests
test.bat
```

## ⚡ For Linux/macOS Users

```bash
# 1. Make scripts executable
chmod +x setup.sh run.sh test.sh

# 2. Run setup
./setup.sh

# 3. Start server
./run.sh

# 4. Open browser to http://localhost:3000

# 5. Run tests (in another terminal)
./test.sh
```

## 🐳 Docker

```bash
# Build and test
docker build -t product-browser .
docker run --rm product-browser

# Run server in Docker
docker run --rm -p 3000:3000 product-browser ./run.sh
# Then open http://localhost:3000
```

## 🎯 What You'll See

- **Modern product grid** with 12 products
- **Search bar** - Type to filter products instantly
- **Category dropdown** - Filter by Electronics, Photography, Audio, Computing
- **Sort dropdown** - Sort by price (low/high)
- **Loading animation** - Smooth transitions when filtering
- **Empty state** - Helpful message when no products match

## 📱 Try These Interactions

1. **Search**: Type "laptop" or "camera"
2. **Filter**: Select "Electronics" category
3. **Sort**: Choose "Price: Low to High"
4. **Reset**: Click "Reset All Filters" in empty state
5. **Hover**: See cards lift with smooth animation
6. **Responsive**: Resize window to see grid adapt

See `README.md` for detailed documentation.

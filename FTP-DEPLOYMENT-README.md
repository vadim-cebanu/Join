# FTP Deployment Instructions - Join Project

## Build Completed Successfully! ✓

**Build Date:** March 28, 2026  
**Base Href:** `/` (root - for subdomain deployment)  
**Subdomain:** `join.vadimcebanu.dev`  
**Routing Strategy:** Hash Location (works without .htaccess)

Your Angular application has been built for production with **Hash Location Strategy** and is ready for FTP deployment to subdomain.

### 🆕 Latest Updates Included:
- ✅ **Attachment System** - File upload, compression, preview, and viewer
- ✅ **Image Compression** - Automatic image optimization with base64 utilities
- ✅ **Drag & Drop** - Upload files by dragging them to the upload area
- ✅ **File Validation** - JPEG/PNG only, 1MB max size with error messages
- ✅ **Dark Theme Upload Button** - Icon after text, consistent styling
- ✅ **16px Attachment Names** - Readable white background with black text
- ✅ **32px Max Arrow Icons** - Consistent dropdown arrow sizing
- ✅ **Task Store Integration** - Centralized task management with signals
- ✅ Contact detail view updates in real-time after editing
- ✅ Strict email validation (max 30 chars, domain extension 2-4 chars)
- ✅ Name field limited to 30 characters
- ✅ Phone field limited to 20 characters
- ✅ Improved form validation with maxLength constraints

### 🔗 URL Format with Subdomain:

Your URLs will look like:
- Home: `https://join.vadimcebanu.dev/#/`
- Login: `https://join.vadimcebanu.dev/#/login`
- Signup: `https://join.vadimcebanu.dev/#/signup`
- Summary: `https://join.vadimcebanu.dev/#/summary`
- Board: `https://join.vadimcebanu.dev/#/board`
- Contacts: `https://join.vadimcebanu.dev/#/contacts`

**Why Hash?** The `#` makes routing work without server configuration. Perfect for servers that don't support `.htaccess` or URL rewriting!

### 📁 Files Location

All deployment files are located in:
```
dist/join-project/browser/
```

### 📤 FTP Upload Instructions for Subdomain

⚠️ **Your server subdomain configuration:** `join` → `/join`

This means the subdomain `join.vadimcebanu.dev` points to the `/join` folder on your server.

1. **Connect to your FTP server** using your preferred FTP client (FileZilla, WinSCP, etc.)

2. **Navigate to the `/join` folder** on your server:
   - This is typically: `public_html/join/` or `www/join/`

3. **Delete old files** from the `/join` folder (if any exist):
   - Old `index.html`
   - Old `.js` and `.css` files
   - Keep `assets/` and `media/` folders (or replace them)

4. **Upload ALL files from `dist/join-project/browser/`** INTO the `/join` folder:
   ```
   public_html/
     └── join/                    <-- Upload files HERE
         ├── index.html           <-- New file (base href="/")
         ├── main-5Z4VQY7V.js    <-- Angular app bundle
         ├── styles-J5L2ZLGQ.css <-- Styles
         ├── assets/             <-- All assets
         │   ├── fonts/
         │   ├── icons/
         │   └── images/
         └── media/              <-- Font files
             ├── inter-v20-latin-regular-55WT6UWF.woff2
             ├── inter-v20-latin-500-W62DVTXI.woff2
             └── inter-v20-latin-700-SU5XVJMF.woff2
   ```

5. **Server configuration is already set:**
   - Subdomain: `join` → Path: `/join` ✓
   - No additional server configuration needed!

6. **Access your app at:**
   ```
   https://join.vadimcebanu.dev/
   ```
   or with hash routing:
   ```
   https://join.vadimcebanu.dev/#/
   https://join.vadimcebanu.dev/#/login
   https://join.vadimcebanu.dev/#/summary
   ```

### ⚠️ Common Issues & Solutions

**404 Errors for JS/CSS files?**
- ✅ Clear the `/join` folder completely before uploading
- ✅ Make sure `index.html` has `<base href="/">`
- ✅ Verify subdomain configuration: `join` → `/join`
- ✅ Clear browser cache (Ctrl+Shift+Delete)

**Fonts not loading?**
- ✅ Ensure `media/` folder with .woff2 files is in `/join/media/`
- ✅ Check font URLs in browser DevTools

**Images not showing?**
- ✅ Verify `assets/` folder structure is preserved in `/join/assets/`
- ✅ Check that icons are in: `/join/assets/icons/`

**Subdomain not resolving?**
- ✅ DNS propagation can take up to 48 hours
- ✅ Verify subdomain configuration in hosting panel
- ✅ Try accessing with `www` removed: `join.vadimcebanu.dev`

### ⚙️ Important Notes

- **Base Href**: Built with `<base href="/">` - works at subdomain root
- **Subdomain Setup**: Server maps `join.vadimcebanu.dev` → `/join` folder
- **No subfolder path**: App expects files at root of subdomain (not `/join/join/`)
- **Apache Web Server**: The included `.htaccess` file is for Apache servers
- **HTTPS**: Your site uses HTTPS - ensure all resources load over HTTPS

### 🔒 Supabase Configuration

Make sure your Supabase project settings allow requests from your domain:
1. Go to Supabase Dashboard → Settings → API
2. Add `https://join.vadimcebanu.dev` to the allowed URLs
3. Update CORS settings if needed

### 🎨 Build Information

- **Bundle size**: 902.45 kB raw / ~176 kB compressed
- **Component styles**: Optimized within 35kB budget
- **All files minified**: Production-ready with compression

### 🧪 Testing After Deployment

1. Visit `https://join.vadimcebanu.dev/`
2. Check browser DevTools Console for errors
3. Verify all assets load (JS, CSS, fonts, images)
4. Test all routes with hash navigation
5. Test login/signup functionality
6. Verify Supabase connection works

### 🧪 Testing After Deployment

1. Visit your domain (e.g., `http://join-4-1226.developerakademie.net/`)
2. Test all routes (note the # in URLs):
   - `/#/login` - User login page
   - `/#/signup` - New user registration
   - `/#/summary` - Dashboard summary
   - `/#/board` - Kanban board view
   - `/#/contacts` - Contact management
   - `/#/help` - Help documentation
3. **Refresh works!** With hash routing, refresh on any page will work perfectly
4. Test contact operations:
   - Create new contact with validation (name max 30 chars, email max 30 chars, phone max 20 chars)
   - Edit contact and verify detail view updates automatically
   - Delete contact
   - Test email validation (must be valid format with 2-4 char domain extension)
5. Test guest login functionality
6. Test responsive behavior (contact list, animations, FAB menu)

### 📊 File Structure on Server

Your server's public directory should look like:
```
public_html/
├── index.html
├── main-RCYXK5PC.js
├── styles-J5L2ZLGQ.css
├── assets/
│   ├── fonts/
│   ├── icons/
│   ├── images/
│   └── img/
└── media/
```

### 🔄 For Future Updates

When you need to update the app:
1. Run `npm run build` again
2. Upload the new files from `dist/join-project/browser/`
3. Overwrite existing files on the server
4. Clear browser cache (Ctrl+Shift+R or Cmd+Shift+R)

### 🆘 Troubleshooting

**Problem**: Routes show 404 on refresh
- **Solution**: This should NOT happen with hash routing! If it does, verify all files were uploaded correctly.

**Problem**: URLs don't have `#` in them
- **Solution**: Make sure you uploaded the latest build files. The new build uses hash location strategy.

**Problem**: App doesn't load
- **Solution**: Check browser console for errors, verify all files were uploaded correctly

**Problem**: Supabase connection errors
- **Solution**: Verify your domain is allowed in Supabase Dashboard → Settings → API

**Problem**: Form validation not working
- **Solution**: Clear browser cache and reload (Ctrl+Shift+R)

**Problem**: Contact detail doesn't update after editing
- **Solution**: This should be fixed in the latest build. Clear cache and try again.

**Problem**: Styles not loading correctly
- **Solution**: Make sure `styles-J5L2ZLGQ.css` was uploaded correctly

**Problem**: Success message doesn't appear when creating tasks
- **Solution**: Clear browser cache (Ctrl+Shift+R) and verify all files were uploaded

**Problem**: Search results not showing "No results" message
- **Solution**: Verify latest build files were uploaded, clear cache

---

## ✅ Ready to Deploy!

**Total size:** ~725 KB (compressed: ~159 KB)  
**Routing:** Hash Location Strategy (no server configuration needed!)

Connect to your FTP server and upload all files from the `browser` folder to start using your Join Kanban application!

**After upload, access your app at:**
- `http://join-4-1226.developerakademie.net/` (redirects to `#/login`)
- Or directly: `http://join-4-1226.developerakademie.net/#/login`

**No more 404 errors!** The hash routing works on any server without special configuration. 🚀

**Questions?** Check the troubleshooting section above or verify that all files were uploaded correctly.

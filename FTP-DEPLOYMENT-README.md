# FTP Deployment Instructions - Join Project

## Build Completed Successfully! ✓

**Build Date:** March 28, 2026  
**Base Href:** `/join/` (deployed in subfolder - lowercase)  
**Routing Strategy:** Hash Location (works without .htaccess)

Your Angular application has been built for production with **Hash Location Strategy** and is ready for FTP deployment.

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

### 🔗 URL Format with Hash Location:

Your URLs will look like:
- Home: `https://join.vadimcebanu.dev/join/#/`
- Login: `https://join.vadimcebanu.dev/join/#/login`
- Signup: `https://join.vadimcebanu.dev/join/#/signup`
- Summary: `https://join.vadimcebanu.dev/join/#/summary`
- Board: `https://join.vadimcebanu.dev/join/#/board`
- Contacts: `https://join.vadimcebanu.dev/join/#/contacts`

**Why Hash?** The `#` makes routing work without server configuration. Perfect for servers that don't support `.htaccess` or URL rewriting!

### 📁 Files Location

All deployment files are located in:
```
dist/join-project/browser/
```

### 📤 FTP Upload Instructions - IMPORTANT!

⚠️ **CRITICAL: The app MUST be uploaded to a `join` subfolder on your server!**

1. **Connect to your FTP server** using your preferred FTP client (FileZilla, WinSCP, etc.)

2. **Create a folder named `join`** (lowercase!) in your web server's public directory:
   - Usually named: `public_html`, `www`, `htdocs`, or `web`
   - Create folder: `public_html/join/`

3. **Upload ALL files from `dist/join-project/browser/`** INTO the `join` folder:
   ```
   public_html/
     └── join/                    <-- Create this folder (lowercase!)
         ├── index.html           <-- Upload here
         ├── main-5Z4VQY7V.js    <-- Upload here
         ├── styles-J5L2ZLGQ.css <-- Upload here
         ├── assets/             <-- Upload entire folder
         └── media/              <-- Upload entire folder
   ```

4. **Final structure on server:**
   ```
   public_html/
     └── join/
         ├── index.html
         ├── main-5Z4VQY7V.js
         ├── styles-J5L2ZLGQ.css
         ├── assets/
         │   ├── fonts/
         │   ├── icons/
         │   └── images/
         └── media/
             ├── inter-v20-latin-regular-55WT6UWF.woff2
             ├── inter-v20-latin-500-W62DVTXI.woff2
             └── inter-v20-latin-700-SU5XVJMF.woff2
   ```

5. **Access your app at:**
   ```
   https://join.vadimcebanu.dev/join/
   ```
   or
   ```
   https://join.vadimcebanu.dev/join/#/
   ```

### ⚠️ Common Issues & Solutions

**404 Errors for JS/CSS files?**
- ✅ Make sure the `join` folder exists on the server (lowercase!)
- ✅ Verify all files are INSIDE the `join` folder, not in `public_html` root
- ✅ Check folder name is `join` (lowercase j) not `Join`
- ✅ Clear browser cache (Ctrl+Shift+Delete)

**Fonts not loading?**
- ✅ Ensure `media/` folder with .woff2 files is uploaded
- ✅ Check that fonts are in: `public_html/join/media/`

**Images not showing?**
- ✅ Verify `assets/` folder structure is preserved
- ✅ Check that icons are in: `public_html/join/assets/icons/`

### ⚙️ Important Notes

- **Base Href**: Built with `--base-href /join/` - app expects to be in `/join/` subfolder
- **Lowercase**: The folder MUST be named `join` (lowercase j) to match the build
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

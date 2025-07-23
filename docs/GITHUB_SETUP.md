# Quick Setup Guide for GitHub Pages

## Step 1: Create GitHub Repository

1. Go to GitHub and create a new repository
2. Name it `my_petrol_monitoring` (or your preferred name)
3. Set it to Public (required for free GitHub Pages)
4. Don't initialize with README (we already have one)

## Step 2: Connect Local Repository

Open terminal in your project folder and run:

```bash
git init
git add .
git commit -m "Initial commit - Malaysia Petrol Monitoring App"
git branch -M main
git remote add origin https://github.com/YOURUSERNAME/my_petrol_monitoring.git
git push -u origin main
```

Replace `YOURUSERNAME` with your actual GitHub username.

## Step 3: Enable GitHub Pages

1. Go to your repository on GitHub
2. Click **Settings** tab
3. Scroll to **Pages** section
4. Under **Source**, select "Deploy from a branch"
5. Select branch: `gh-pages` (will be created automatically by Actions)
6. Click **Save**

## Step 4: Configure Actions

1. Go to **Actions** tab in your repository
2. If prompted, enable Actions for your repository
3. The workflow file `.github/workflows/deploy.yml` will automatically trigger

## Step 5: Update Configuration (if needed)

If your repository name is different from `my_petrol_monitoring`, update:

1. `.github/workflows/deploy.yml` - change the `--base-href` value
2. Build scripts in `scripts/` folder
3. README.md links

## Step 6: Deploy

Push any changes to the `main` branch to trigger deployment:

```bash
git add .
git commit -m "Update for GitHub Pages"
git push origin main
```

## Your Live App

After deployment (usually 2-5 minutes), your app will be available at:
`https://YOURUSERNAME.github.io/my_petrol_monitoring/`

## Need Help?

Check the deployment checklist in `docs/DEPLOYMENT_CHECKLIST.md` for troubleshooting.

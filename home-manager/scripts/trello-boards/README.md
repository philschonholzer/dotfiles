# Trello Board Selector

A fuzzel-based Trello board selector that opens boards in a Chromium webapp.

## Setup

1. Get your Trello API credentials:
   - Visit <https://trello.com/app-key>
   - Copy your API key
   - Click the "Token" link to generate a token
   - Copy the token

2. Create a `.env` file in your home directory:

   ```bash
   cp ~/nixos-config/home-manager/scripts/trello-boards/.env.example ~/.env
   ```

3. Edit the `.env` file and add your credentials:

   ```bash
   TRELLO_API_KEY=your-api-key-here
   TRELLO_TOKEN=your-token-here
   ```

4. Rebuild your home-manager configuration:

   ```bash
   home-manager switch --flake .#philip
   ```

## Usage

Run the command:

```bash
tb
```

Or use the full path:

```bash
~/open-trello-board
```

This will:

1. Fetch all your open Trello boards
2. Display them in fuzzel for selection
3. Open the selected board in a Chromium webapp (Work profile)

## Dependencies

- `curl` - for API requests
- `jq` - for JSON parsing
- `fuzzel` - for selection interface
- `chromium` - for webapp display

All dependencies are included in your NixOS configuration.

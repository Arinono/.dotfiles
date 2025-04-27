{pkgs, ...}: {
  sh = pkgs.writeShellApplication {
    name = "convert";
    runtimeInputs = [pkgs.ffmpeg pkgs.toybox pkgs.fzf pkgs.fd];

    text = ''
      set +o nounset
      set -e

      file="$1"

      if [[ -z "$file" ]]; then
        file=$(fd -e .mov -e .mp4 --changed-within 1week . ~/Downloads/ | fzf)
      fi

      if [[ -z "$file" ]]; then
        echo "Usage: convert [file]"
        echo "Or select a file"
        exit 1
      fi

      formats="gif mp4s mp4ns discord_sticker"

      dir=$(dirname "$file")
      name=$(basename "$file" | sed 's/\.mov//' | sed 's/\.gif//')
      selected_format=$(echo "$formats" | tr ' ' '\n' | fzf)

      if [[ -z "$selected_format" ]]; then
        echo "Please select a format"
        exit 1
      fi

      if [[ "$selected_format" == "gif" ]]; then
        ffmpeg -i "$file" -r 10 \
          -vf "scale=1920:1080:force_original_aspect_ratio=decrease" "$dir/$name.gif"
      elif [[ "$selected_format" == "discord_sticker" ]]; then
        ffmpeg -i "$file" -plays 0 \
          -vf "setpts=PTS_STARTPTS, scale=320:320:1080:force_original_aspect_ratio=decrease" \
          "$dir/$name.apng"
        mv "$dir/$name.apng" "$dir/$name.png"
      elif [[ "$selected_format" == "mp4s" ]]; then
        ffmpeg -i "$file" -r 30 -vcodec h264 -acodec aac \
          -vf "scale=1920:1080:force_original_aspect_ratio=decrease" "$dir/$name.mp4"
      elif [[ "$selected_format" == "mp4ns" ]]; then
        ffmpeg -i "$file" -r 30 -vcodec h264 -an \
          -vf "scale=1920:1080:force_original_aspect_ratio=decrease" "$dir/$name.mp4"
      fi
    '';
  };
}

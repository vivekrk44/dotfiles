###
  #
  # @brief: A utility file with functions that are used often 
  #
###


import os
import random 

def random_wallpaper(directory):
  """
  Returns a random filename from the specified directory.

  Args:
      directory (str): The path to the directory.

  Returns:
      str: The randomly selected filename.

  Raises:
      FileNotFoundError: If the directory does not exist.
      ValueError: If the directory is empty.
  """

  # Check if the directory exists
  if not os.path.exists(directory):
      raise FileNotFoundError(f"Directory not found: {directory}")

  # Get a list of filenames in the directory
  filenames = os.listdir(directory)

  # Ensure the directory is not empty
  if not filenames:
      raise ValueError("Directory is empty")

  # Filter out non-file entries
  filenames = [filename for filename in filenames if os.path.isfile(os.path.join(directory, filename))]

  # Select a random filename from the list
  random.seed()
  random_filename = random.choice(filenames)

  return os.path.join(directory, random_filename)


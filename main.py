from pynput.mouse import Controller, Button
import time
import random
from datetime import datetime

# Mouse controller instance
mouse = Controller()

# Button coordinates (replace with your recorded values)
roll_button = (115, 408)
max_balls = (69, 316)
twox_button = (140, 285)
halfx_button = (117, 285)
bet_all_button = (76, 353)

# Range for random delta
DELTA_RANGE = (-5, 5)  # Adjust this range if needed

def log(message):
    """Log a message with a timestamp."""
    print(f"[{datetime.now().strftime('%Y-%m-%d %H:%M:%S')}] {message}")

def add_random_delta(coords):
    """Add a random delta to the given coordinates."""
    delta_x = random.randint(*DELTA_RANGE)
    delta_y = random.randint(*DELTA_RANGE)
    return (coords[0] + delta_x, coords[1] + delta_y)

def move_mouse_smoothly(start, end, duration):
    """Move the mouse smoothly from start to end within the given duration."""
    steps = int(duration * 100)  # Number of small movements (e.g., 100 per second)
    start_x, start_y = start
    end_x, end_y = end
    for i in range(steps):
        # Calculate intermediate position
        x = start_x + (end_x - start_x) * i / steps
        y = start_y + (end_y - start_y) * i / steps
        mouse.position = (x, y)
        time.sleep(0.01)  # Wait a bit between steps to simulate smooth movement

def click_button(coords, name):
    """Move to the button with random delta, click, and log the action."""
    coords_with_delta = add_random_delta(coords)
    start_position = mouse.position  # Get current mouse position
    move_mouse_smoothly(start_position, coords_with_delta, duration=random.uniform(0.5, 1.0))
    mouse.click(Button.left)  # Perform a left click
    log(f"Clicked {name} button at {coords_with_delta}")

def random_delay(base_time, jitter):
    """Add a base delay with a random jitter and log the delay."""
    delay = base_time + random.uniform(0, jitter)
    log(f"Waiting for {delay:.2f} seconds")
    time.sleep(delay)

# Main strategy loop
log("Starting Plinko bot...")
while True:
    # Step 1: Click the bet_all_button
    click_button(bet_all_button, "Bet All")
    random_delay(0.5, 0.2)  # Small delay between actions

    # Step 2: Click halfx_button 6 times
    for i in range(6):
        click_button(halfx_button, f"Half (Click {i + 1}/6)")
        random_delay(0.5, 0.2)

    # Step 3: Click max_balls button
    click_button(max_balls, "Max Balls")
    random_delay(0.5, 0.2)

    # Step 4: Click roll button
    click_button(roll_button, "Roll")

    # Step 5: Wait for the game to complete (16 seconds + random 1-2 seconds)
    random_delay(16, 2)

    # Log round completion
    log("Round completed. Starting next round...")

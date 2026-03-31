/**
 * Image compression and base64 utility functions.
 *
 * This module provides utilities for image compression, base64 encoding,
 * and dimension calculations following the code convention of max 14 lines per function.
 */

/**
 * Represents the calculated dimensions for image resizing.
 */
export interface ImageDimensions {
  width: number;
  height: number;
}

/**
 * Reads a file and converts it to a base64 data URL.
 *
 * @param file - The file to read.
 * @returns Promise resolving to the base64 data URL string.
 * @throws Error if file reading fails.
 */
export function readFileAsDataURL(file: File): Promise<string> {
  return new Promise((resolve, reject) => {
    const reader = new FileReader();
    reader.onload = (event) => resolve(event.target?.result as string);
    reader.onerror = () => reject(new Error('Error reading file'));
    reader.readAsDataURL(file);
  });
}

/**
 * Loads an image from a base64 data URL.
 *
 * @param dataURL - The base64 data URL string.
 * @returns Promise resolving to the loaded Image element.
 * @throws Error if image loading fails.
 */
export function loadImage(dataURL: string): Promise<HTMLImageElement> {
  return new Promise((resolve, reject) => {
    const img = new Image();
    img.onload = () => resolve(img);
    img.onerror = () => reject(new Error('Error loading image'));
    img.src = dataURL;
  });
}

/**
 * Calculates new dimensions for an image while maintaining aspect ratio.
 *
 * @param originalWidth - Original width of the image.
 * @param originalHeight - Original height of the image.
 * @param maxWidth - Maximum allowed width.
 * @param maxHeight - Maximum allowed height.
 * @returns The calculated dimensions.
 */
export function calculateImageDimensions(
  originalWidth: number,
  originalHeight: number,
  maxWidth: number,
  maxHeight: number
): ImageDimensions {
  let width = originalWidth;
  let height = originalHeight;

  if (width > maxWidth || height > maxHeight) {
    if (width > height) {
      height = (height * maxWidth) / width;
      width = maxWidth;
    } else {
      width = (width * maxHeight) / height;
      height = maxHeight;
    }
  }

  return { width, height };
}

/**
 * Creates a canvas and draws an image on it with specified dimensions.
 *
 * @param img - The image to draw.
 * @param width - Target width.
 * @param height - Target height.
 * @returns The canvas element with the drawn image.
 * @throws Error if canvas context cannot be obtained.
 */
export function createCanvasWithImage(
  img: HTMLImageElement,
  width: number,
  height: number
): HTMLCanvasElement {
  const canvas = document.createElement('canvas');
  const ctx = canvas.getContext('2d');

  if (!ctx) {
    throw new Error('Failed to get canvas context');
  }

  canvas.width = width;
  canvas.height = height;
  ctx.drawImage(img, 0, 0, width, height);

  return canvas;
}

/**
 * Converts a canvas to a base64 data URL with specified format.
 *
 * @param canvas - The canvas to convert.
 * @param mimeType - The image MIME type (e.g., 'image/jpeg', 'image/png').
 * @param quality - Image quality (0-1, default: 0.7). Only applies to lossy formats like JPEG.
 * @returns Base64 encoded data URL.
 */
export function canvasToBase64(canvas: HTMLCanvasElement, mimeType: string = 'image/jpeg', quality: number = 0.7): string {
  return canvas.toDataURL(mimeType, quality);
}

/**
 * Compresses an image file to a specified size and quality, preserving the original format.
 *
 * @param file - The image file to compress.
 * @param maxWidth - Maximum width (default: 800px).
 * @param maxHeight - Maximum height (default: 800px).
 * @param quality - Image quality 0-1 (default: 0.7). Only applies to lossy formats like JPEG.
 * @returns Promise resolving to base64 encoded compressed image.
 */
export async function compressImage(
  file: File,
  maxWidth: number = 800,
  maxHeight: number = 800,
  quality: number = 0.7
): Promise<string> {
  const dataURL = await readFileAsDataURL(file);
  const img = await loadImage(dataURL);
  const dimensions = calculateImageDimensions(img.width, img.height, maxWidth, maxHeight);
  const canvas = createCanvasWithImage(img, dimensions.width, dimensions.height);
  return canvasToBase64(canvas, file.type, quality);
}

/**
 * Calculates the file size in bytes from a base64 string.
 *
 * @param base64String - The base64 encoded string.
 * @returns Size in bytes.
 */
export function calculateBase64Size(base64String: string): number {
  return (base64String.length * 3) / 4;
}

/**
 * Calculates the file size in kilobytes from a base64 string.
 *
 * @param base64String - The base64 encoded string.
 * @returns Size in kilobytes (rounded).
 */
export function calculateBase64SizeKB(base64String: string): number {
  const sizeInBytes = calculateBase64Size(base64String);
  return Math.round(sizeInBytes / 1024);
}

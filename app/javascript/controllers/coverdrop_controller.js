// from here: https://web-crunch.com/posts/rails-drag-drop-active-storage-stimulus-dropzone
import { Controller } from "@hotwired/stimulus";
import Dropzone from "dropzone";
import { DirectUpload } from "@rails/activestorage";
import {
  getMetaValue,
  toArray,
  findElement,
  removeElement,
  insertAfter,
} from "../helpers/index";

// Connects to data-controller="coverdrop"
// enables drag and drop attachments
export default class extends Controller {
  static targets = ["input"];

  connect() {
    this.dropZone = createDropZone(this);
    this.hideFileInput();
    this.bindEvents();
    Dropzone.autoDiscover = false;
  }

  // Private

  // hide the file input field
  hideFileInput() {
    this.inputTarget.disabled = true;
    this.inputTarget.style.display = "none";
  }

  // bind the different dropzone events
  bindEvents() {
    this.dropZone.on("addedfile", (file) => {
      setTimeout(() => {
        file.accepted && createDirectUploadController(this, file).start();
      }, 500);
    });

    this.dropZone.on("removedfile", (file) => {
      file.controller && removeElement(file.controller.hiddenInput);
    });

    this.dropZone.on("canceled", (file) => {
      file.controller && file.controller.xhr.abort();
    });
  }

  // get the cross-forgery token
  get headers() {
    return { "X-CSRF-Token": getMetaValue("csrf-token") };
  }

  // get the URL from the file input field
  get url() {
    return this.inputTarget.getAttribute("data-direct-upload-url");
  }

  // below are the getters for various variables
  get maxFiles() {
    return this.data.get("max-files") || 1;
  }

  get maxFileSize() {
    return this.data.get("maxFileSize") || 256;
  }

  get acceptedFile() {
    return this.data.get("acceptedFiles");
  }

  get addRemoveLinks() {
    return this.data.get("addRemoveLinks") || true;
  }
}

// Basic ES6 class
class DirectUploadController {
  constructor(source, file) {
    // create new directUpload from activestorage
    this.directUpload = createDirectUpload(file, source.url, this);
    // make variables available within the class
    this.source = source;
    this.file = file;
  }

  start() {
    this.file.controller = this;
    this.hiddenInput = this.createHiddenInput();
    // activestorage
    this.directUpload.create((error, attributes) => {
      if (error) {
        removeElement(this.hiddenInput);
        this.emitDropzoneError(error);
      } else {
        // below is part of Ajax
        this.hiddenInput.value = attributes.signed_id;
        this.emitDropzoneSuccess();
      }
    });
  }

  // create a hidden input field on the fly
  createHiddenInput() {
    const input = document.createElement("input");
    input.type = "hidden";
    input.name = this.source.inputTarget.name;
    insertAfter(input, this.source.inputTarget);
    return input;
  }

  // activestorage ajax
  directUploadWillStoreFileWithXHR(xhr) {
    this.bindProgressEvent(xhr);
    this.emitDropzoneUploading();
  }

  bindProgressEvent(xhr) {
    this.xhr = xhr;
    this.xhr.upload.addEventListener("progress", (event) =>
      this.uploadRequestDidProgress(event)
    );
  }

  // check how much progress has been made
  uploadRequestDidProgress(event) {
    const element = this.source.element;
    const progress = (event.loaded / event.total) * 100;
    findElement(
      this.file.previewTemplate,
      ".dz-upload"
    ).style.width = `${progress}%`;
  }

  // some text to show based on various events
  emitDropzoneUploading() {
    this.file.status = Dropzone.UPLOADING;
    this.source.dropZone.emit("processing", this.file);
  }

  emitDropzoneError(error) {
    this.file.status = Dropzone.ERROR;
    this.source.dropZone.emit("error", this.file, error);
    this.source.dropZone.emit("complete", this.file);
  }

  emitDropzoneSuccess() {
    this.file.status = Dropzone.SUCCESS;
    this.source.dropZone.emit("success", this.file);
    this.source.dropZone.emit("complete", this.file);
  }
}

// simple wrapper to create an uploadController defined above
function createDirectUploadController(source, file) {
  return new DirectUploadController(source, file);
}

// wrapper for activestorage method
function createDirectUpload(file, url, controller) {
  return new DirectUpload(file, url, controller);
}

// create the dropzone
function createDropZone(controller) {
  return new Dropzone(controller.element, {
    // parameters come from the getter methods above
    url: controller.url,
    headers: controller.headers,
    maxFiles: controller.maxFiles,
    maxFilesize: controller.maxFileSize,
    acceptedFiles: controller.acceptedFiles,
    addRemoveLinks: controller.addRemoveLinks,
    autoQueue: false,
  });
}

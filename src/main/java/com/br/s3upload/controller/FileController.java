package com.br.s3upload.controller;

import com.br.s3upload.model.FileUploadResponse;
import com.br.s3upload.service.S3Service;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

import java.io.IOException;
import java.util.List;

@RestController
@RequestMapping("/files")
public class FileController {

    private final S3Service s3Service;

    public FileController(S3Service s3Service) {
        this.s3Service = s3Service;
    }

    @PostMapping("/upload")
    public ResponseEntity<FileUploadResponse> upload(@RequestParam("file") MultipartFile file) throws IOException {
        String key = s3Service.uploadFile(file);
        return ResponseEntity.ok(new FileUploadResponse(key, "/files/" + key));
    }

    @GetMapping
    public ResponseEntity<List<String>> list() {
        return ResponseEntity.ok(s3Service.listFiles());
    }

    @DeleteMapping("/{key}")
    public ResponseEntity<Void> delete(@PathVariable String key) {
        s3Service.deleteFile(key);
        return ResponseEntity.noContent().build();
    }
}
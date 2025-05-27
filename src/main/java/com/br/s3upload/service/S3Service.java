package com.br.s3upload.service;

import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;
import software.amazon.awssdk.core.sync.RequestBody;
import software.amazon.awssdk.services.s3.S3Client;
import software.amazon.awssdk.services.s3.model.*;

import java.io.IOException;
import java.util.Collections;
import java.util.List;
import java.util.stream.Collectors;

@Service
@Slf4j
public class S3Service {

    private final S3Client s3Client;

    @Value("${aws.s3.bucket}")
    private String bucketName;

    public S3Service(S3Client s3Client) {
        this.s3Client = s3Client;
    }

    public String uploadFile(MultipartFile file) {
        String key = file.getOriginalFilename();
        try {
            log.info("Iniciando upload do arquivo: {}", key);

            PutObjectRequest putRequest = PutObjectRequest.builder()
                    .bucket(bucketName)
                    .key(key)
                    .build();

            s3Client.putObject(putRequest, RequestBody.fromBytes(file.getBytes()));

            log.info("Upload realizado com sucesso: {}", key);
            return key;

        } catch (IOException e) {
            log.error("Erro ao ler bytes do arquivo: {}", key, e);
            throw new RuntimeException("Erro ao ler bytes do arquivo.", e);
        } catch (S3Exception e) {
            log.error("Erro da AWS S3 ao enviar arquivo: {}", key, e);
            throw new RuntimeException("Erro da AWS S3 ao enviar arquivo.", e);
        } catch (Exception e) {
            log.error("Erro inesperado ao enviar arquivo: {}", key, e);
            throw new RuntimeException("Erro inesperado ao enviar arquivo.", e);
        }
    }

    public List<String> listFiles() {
        try {
            log.info("Listando arquivos no bucket: {}", bucketName);

            ListObjectsV2Request request = ListObjectsV2Request.builder()
                    .bucket(bucketName)
                    .build();

            ListObjectsV2Response response = s3Client.listObjectsV2(request);

            List<String> arquivos = response.contents().stream()
                    .map(S3Object::key)
                    .collect(Collectors.toList());

            log.info("Arquivos encontrados: {}", arquivos.size());
            return arquivos;

        } catch (S3Exception e) {
            log.error("Erro ao listar arquivos no S3", e);
            return Collections.emptyList();
        } catch (Exception e) {
            log.error("Erro inesperado ao listar arquivos", e);
            return Collections.emptyList();
        }
    }

    public void deleteFile(String key) {
        try {
            log.info("Iniciando exclusão do arquivo: {}", key);

            DeleteObjectRequest deleteRequest = DeleteObjectRequest.builder()
                    .bucket(bucketName)
                    .key(key)
                    .build();

            s3Client.deleteObject(deleteRequest);

            log.info("Arquivo deletado com sucesso: {}", key);

        } catch (S3Exception e) {
            log.error("Erro da AWS S3 ao deletar o arquivo: {}", key, e);
            throw new RuntimeException("Erro da AWS S3 ao deletar o arquivo.", e);
        } catch (Exception e) {
            log.error("Erro inesperado ao deletar o arquivo: {}", key, e);
            throw new RuntimeException("Erro inesperado ao deletar o arquivo.", e);
        }
    }
}

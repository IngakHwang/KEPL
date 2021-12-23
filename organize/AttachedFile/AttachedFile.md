[첨부파일 업로드 기능 구현](https://cameldev.tistory.com/68)을 참고하였습니다.



### **1. 첨부파일 업로드 처리 방식**

 이번 게시판 프로젝트에서는 파일데이터와 <form> 태그의 데이터를 구분해서 전송하는 방식을 사용해서 첨부파일 업로드 처리를 구현해보도록 하겠습니다. 

 Ajax 방식으로 파일데이터와 <form> 데이터를 구분해서 전송하는 방식으로 구현하겠습니다. 먼저 Ajax 통신을 통해 파일을 서버에 저장하고, 게시글 작성을 하면 서버에 저장된 파일명과 게시글 정보를 <form> 태그를 통해 데이터베이스 테이블에 저장하게 됩니다. 

 

### **2. Spring에서의 파일 업로드 기능 설정** 



#### **2-1. pom.xml 파일 수정**

Spring에서 파일 업로드 기능을 구현하기 위해서 아래와 같이 pom.xml 파일에 라이브러리를 추가해줍니다. 

```java
<dependency>
  <groupId>commons-fileupload</groupId>
  <artifactId>commons-fileupload</artifactId>
  <version>1.3.2</version>
</dependency>
<dependency>
  <groupId>org.imgscalr</groupId>
  <artifactId>imgscalr-lib</artifactId>
  <version>4.2</version>
</dependency>
```

#### **2-2. servlet-context.xml 파일 수정**

Spring에서는 파일 업로드를 처리하기 위해 파일 업로드로 들어오는 데이터를 처리하는 객체가 필요하고, 그것을 위해 servlet-context.xml 파일에 아래의 내용을 추가해주겠습니다. 

```java
<beans:bean id="multipartResolver" class="org.springframework.web.multipart.commons.CommonsMultipartResolver">
    	<beans:property name="maxUploadSize" value="10485760"/>
</beans:bean>
```

#### **2-3. root-context.xml 파일 수정**

파일 업로드 경로를 root-context.xml 파일에서 정의해 주겠습니다.

```JAVA
// 파일 업로드 경로를 설정
<bean id="uploadPath" class="java.lang.String">
  <constructor-arg value="C:\\Users\\cameldev\\eclipse-workspace\\mypage\\src\\main\\webapp\\resources\\upload">
  </constructor-arg>
</bean>
```

#### **2-4. web.xml 파일 수정**

업로드를 할 때 한글 파일명이 정상적으로 출력이 되지않는 것을 방지하기 위해서 아래와 같이 필터 설정을 해줍니다. 

```JAVA
<!--한글 인코딩 설정-->
<filter>
    <filter-name>encoding</filter-name>
    <filter-class>org.springframework.web.filter.CharacterEncodingFilter</filter-class>
    <init-param>
        <param-name>encoding</param-name>
        <param-value>UTF-8</param-value>
    </init-param>
</filter>
<filter-mapping>
    <filter-name>encoding</filter-name>
    <url-pattern>/*</url-pattern>
</filter-mapping>
```

### **3. 첨부파일 테이블 생성**

게시글의 첨부파일 정보를 저장하기 위한 tb_article_file 테이블을 생성해 주겠습니다. 

```java
CREATE TABLE tb_article_file (
  fullname VARCHAR(150) NOT NULL ,
  article_no INT NOT NULL ,
  reg_date TIMESTAMP DEFAULT NOW(),
  PRIMARY KEY (fullname)
);

ALTER TABLE tb_article_file ADD CONSTRAINT fk_article_file
FOREIGN KEY (article_no) REFERENCES tb_article (article_no);

ALTER TABLE tb_article ADD COLUMN file_cnt INT DEFAULT 0;
```

### **4. ArticleVO 수정**

데이터 베이스의 테이블이 변경되었기 때문에 ArticleVO 클래스에 추가적으로 멤버변수를 선언해 주겠습니다. 

```JAVA
private String[] files;
    
private int fileCnt;

Getter,Setter,toString()....
```

### **5. 파일 업로드 처리를 위한 유틸 클래스 작성**

서버에 파일을 저장할 때에는 동일한 파일명을 저장할 경우, 파일의 단일 저장 경로, 이미지 파일인 경우 브라우저에 출력할 파일의 크기를 고려해야합니다. 

 

 동일한 파일명을 저장할 경우 UUID를 이용해여 고유 값을 생성하고, 원본파일명 앞에 붙여 중복 문제를 해결할 수 있습니다. 

 파일의 단일 저장경로 문제의 경우 단일 경로에 걔속 파일을 저장하게되면 나중에 파일을 검색하고 찾는데 속도 문제가 발생할 수 있기 때문에 파일을 날짜별 폴더에 저장해 관리합니다. 

 이미지 파일인 경우 브라우저에 출력할 파일의 크기는 이미지 파일의 용량이 크게되면 서버에서 브라우저에 많은 양의 데이터를 전송하게 되기때문에 이미지 파일의 축소복, 즉 썸네일을 생성하여 최소한의 데이터를 브라우저에 전송하도록 처리합니다. 

 

이와 같은 처리를 위해 이번 프로젝트에서는 UploadFileUtils MediaUtils 2개의 클래스를 생성하도록 하겠습니다. UploadFileUtils 클래스는 파일 업로드, 삭제, 전송 등의 기능을 처리하는 메소드를 가진 클래스이며, MediaUtils 클래스는 파일의 타입이 이미지인지 아닌지를 판별하는 메소드를 가지고 있는 클래스입니다. 



#### **5-1. UploadFileUtils 클래스 작성**

UploadFileUtils 클래스는 유틸클래스로 사용하기 때문에 기본적인 클래스 내부의 모든 메소드들은 static으로 선언하여 인스턴스 생성 없이 바로 사용 가능하도록 작성하였으며, 파일 업로드 처리, 삭제, 출력을 위한 HttpHeader 설정 메소드는 public으로 선언하여 파일 업로드 컨트롤러에서 바로 접근하여 사용 가능하도록 하였습니다. UploadFileUtils 의 내용은 아래와 같습니다. 



```java
public class UploadFileUtils {

    private static final Logger logger = LoggerFactory.getLogger(UploadFileUtils.class);

    // 파일 업로드 처리
    public static String uploadFile(String uploadPath, String originalName, byte[] fileData) throws Exception {
        // 중복된 이름의 파일을 저장하지 않기 위해 UUID 키값 생성
        UUID uuid = UUID.randomUUID();
        
        // 실제 저장할 파일명 = UUID + _ + 원본파일명
        String savedName = uuid.toString() + "_" + originalName;
        
        // 날짜 경로 = 년 + 월 + 일
        String savedPath = calcPath(uploadPath);
        
        // 파일 객체 생성 = 기본 저장경로 + 날짜경로 + UUID_파일명
        File target = new File(uploadPath + savedPath, savedName);
        
        // fileData를 파일객체에 복사
        FileCopyUtils.copy(fileData, target);
        
        // 파일 확장자 추출
        String formatName = originalName.substring(originalName.lastIndexOf(".") + 1);
        
        // 업로드 파일명 : 썸네일 이미지 파일명 or 일반 파일명
        String uploadFileName = null;
        
        // 확장자에 따라 썸네일 이미지 생성 or 일반 파일 아이콘 생성
        if (MediaUtils.getMediaType(formatName) != null) {
            // 썸네일 이미지 생성, 썸네일 이미지 파일명
            uploadFileName = makeThumbnail(uploadPath, savedPath, savedName);
        } else {
            // 파일 아이콘 생성,
            uploadFileName = makeIcon(uploadPath, savedPath, savedName);
        }
        
        // 업로드 파일명 반환
        return uploadFileName;
    }

    // 1. 날짜별 경로 추출
    private static String calcPath(String uploadPath) {
        Calendar calendar = Calendar.getInstance();
        // 년
        String yearPath = File.separator + calendar.get(Calendar.YEAR);
        // 년 + 월
        String monthPath = yearPath + File.separator + new DecimalFormat("00").format(calendar.get(Calendar.MONTH) + 1);
        // 년 + 월 + 일
        String datePath = monthPath + File.separator + new DecimalFormat("00").format(calendar.get(Calendar.DATE));
        // 파일 저장 기본 경로 + 날짜 경로 생성
        makeDir(uploadPath, yearPath, monthPath, datePath);
        // 날짜 경로 반환

        return datePath;
    }

    // 2. 파일 저장 기본 경로 + 날짜 경로 생성
    private static void makeDir(String uploadPath, String... paths) {
        // 기본 경로 + 날짜 경로가 이미 존재 : 메서드 종료
        if (new File(uploadPath + paths[paths.length - 1]).exists()) {
            return;
        }
        // 날짜 경로가 존재 X : 경로 생성을 위한 반복문 수행
        for (String path : paths) {
            // 기본 경로 + 날짜 경로에 해당하는 파일 객체 생성
            File dirPath = new File(uploadPath + path);
            // 파일 객체에 해당하는 경로가 존재 X
            if (!dirPath.exists()) {
                // 경로 생성
                dirPath.mkdir();
            }
        }
    }

    // 3. 썸네일 생성 : 이미지 파일의 경우
    private static String makeThumbnail(String uploadPath, String path, String fileName) throws Exception {
        // BufferedImage : 실제 이미지 X, 메모리상의 이미지를 의미하는 객체
        // 원본 이미지파일을 메모리에 로딩
        BufferedImage sourceImg = ImageIO.read(new File(uploadPath + path, fileName));
        // 정해진 크기에 맞게 원본이미지를 축소
        BufferedImage destImg = Scalr.resize(sourceImg, Scalr.Method.AUTOMATIC, Scalr.Mode.FIT_TO_HEIGHT, 100);
        // 썸네일 이미지 파일명
        String thumbnailName = uploadPath + path + File.separator + "s_" + fileName;
        // 썸네일 이미지 파일 객체 생성
        File newFile = new File(thumbnailName);
        // 파일 확장자 추출
        String formatName = fileName.substring(fileName.lastIndexOf(".") + 1);
        // 썸네일 파일 저장
        ImageIO.write(destImg, formatName.toUpperCase(), newFile);
        return thumbnailName.substring(uploadPath.length()).replace(File.separatorChar, '/');
    }

    // 4. 아이콘 생성 : 이미지 파일이 아닐 경우
    private static String makeIcon(String uploadPath, String savedPath, String fileName) throws Exception {
        // 아이콘 파일명 = 기본 저장경로 + 날짜경로 + 구분자 + 파일명
        String iconName = uploadPath + savedPath + File.separator + fileName;
        return iconName.substring(uploadPath.length()).replace(File.separatorChar, '/');
    }

    // 파일 삭제처리 메서드
    public static void removeFile(String uploadPath, String fileName) {
        // 파일 확장자 추출
        String formatName = fileName.substring(fileName.lastIndexOf(".") + 1);
        // 파일 확장자를 통해 이미지 파일인지 판별
        MediaType mediaType = MediaUtils.getMediaType(formatName);
        // 이미지 파일일 경우, 원본파일 삭제
        if (mediaType != null) {
            // 원본 이미지의 경로 + 파일명 추출
            // 날짜 경로 추출
            String front = fileName.substring(0, 12);
            // UUID + 파일명 추출
            String end = fileName.substring(14);
            // 원본 이미지 파일 삭제(구분자 변환)
            new File(uploadPath + (front + end).replace('/', File.separatorChar)).delete();
        }
        // 파일 삭제(일반 파일 or 썸네일 이미지 파일 삭제)
        new File(uploadPath + fileName.replace('/', File.separatorChar)).delete();
    }
}
```

#### **5-2. MediaUtils 클래스 작성**

```java
public class MediaUtils {

    private static Map<String, MediaType> mediaMap;

    // meidaMap에 이미지확장자명에 따른 MINEType 저장
    static {
        mediaMap = new HashMap<String, MediaType>();
        mediaMap.put("JPG", MediaType.IMAGE_JPEG);
        mediaMap.put("GIF", MediaType.IMAGE_GIF);
        mediaMap.put("PNG", MediaType.IMAGE_PNG);
    }

    public static MediaType getMediaType(String type) {
        // 이미지 MINEType 꺼내서 반환, 이미지 파일이 아닐 경우 null 반환
        return mediaMap.get(type.toUpperCase());
    }
}
```

### **6. 게시글 작성 페이지에서의 파일 첨부 기능 구현**

#### **6-1. UploadDAO 인터페이스,UploadDAOImpl 클래스 작성**

```java
public interface UploadDAO {

    // 게시글 첨부파일 추가
    public void addAttach(String fullName, Integer article_no) throws Exception;

    // 게시글 첨부파일 조회
    public List<String> getAttach(Integer article_no) throws Exception;

    // 게시글 첨부파일 수정
    public void replaceAttach(String fullName, Integer article_no) throws Exception;

    // 게시글 첨부파일 삭제
    public void deleteAttach(String fullName) throws Exception;

    // 게시글 첨부파일 일괄 삭제
    public void deleteAllAttach(Integer article_no) throws Exception;

    // 특정 게시글의 첨부파일 갯수 갱신
    public void updateAttachCnt(Integer article_no) throws Exception;

}
```

```java
@Repository
public class UploadDAOImpl implements UploadDAO {

    @Inject
    private SqlSession sqlSession;

    private static final String NAMESPACE = "mc.sn.KEPL.mappers.upload.ArticleFileMapper";

    // 게시글 첨부파일 추가
    @Override
    public void addAttach(String fullName, Integer article_no) throws Exception {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("fullName", fullName);
        paramMap.put("article_no", article_no);
        sqlSession.insert(NAMESPACE + ".addAttach", paramMap);
    }

    // 게시글 첨부파일 조회
    @Override
    public List<String> getAttach(Integer article_no) throws Exception {
        return sqlSession.selectList(NAMESPACE + ".getAttach", article_no);
    }

    // 게시글 첨부파일 수정
    @Override
    public void replaceAttach(String fullName, Integer article_no) throws Exception {
        Map<String, Object> paramMap = new HashMap<String, Object>();
        paramMap.put("fullName", fullName);
        paramMap.put("article_no", article_no);
        sqlSession.insert(NAMESPACE + ".replaceAttach", paramMap);
    }

    // 게시글 첨부파일 삭제
    @Override
    public void deleteAttach(String fullName) throws Exception {
        sqlSession.delete(NAMESPACE + ".deleteAttach", fullName);
    }

    // 게시글 첨부파일 일괄 삭제
    @Override
    public void deleteAllAttach(Integer article_no) throws Exception {
        sqlSession.delete(NAMESPACE + ".deleteAllAttach", article_no);
    }

    // 특정 게시글의 첨부파일 갯수 갱신
    @Override
    public void updateAttachCnt(Integer article_no) throws Exception {
        sqlSession.update(NAMESPACE + ".updateAttachCnt", article_no);
    }

}
```

articleFileMapper.xml도 생성하고 아래와 같이 SQL을 작성해주겠습니다. 

```java
<mapper namespace="mc.sn.KEPL.mappers.upload.ArticleFileMapper">
	<!--게시글 첨부파일 추가-->
    <insert id="addAttach">
        INSERT tb_article_file (
            fullname
            , article_no
        ) VALUES (
            #{fullName}
            , #{article_no}
        )
    </insert>

    <!--게시글 첨부파일 조회-->
    <select id="getAttach" resultType="string">
        SELECT
            fullname
        FROM tb_article_file
        WHERE article_no = #{article_no}
        ORDER BY reg_date
    </select>

    <!--게시글 첨부파일 수정-->
    <insert id="replaceAttach">
        INSERT INTO tb_article_file (
            fullname
            , article_no
        ) VALUES (
            #{fullName}
            , #{article_no}
        )
    </insert>

    <!--게시글 첨부파일 삭제-->
    <delete id="deleteAttach">
        DELETE FROM tb_article_file
        WHERE fullname = #{fullName}
    </delete>

    <!--게시글 첨부파일 일괄 삭제-->
    <delete id="deleteAllAttach">
        DELETE FROM tb_article_file
        WHERE article_no = #{article_no}
    </delete>

    <!--특정 게시글의 첨부파일 갯수 갱신-->
    <update id="updateAttachCnt">
        UPDATE tb_article
        SET file_cnt = (SELECT COUNT(fullname) FROM tb_article_file WHERE article_no = #{article_no})
        WHERE article_no = #{article_no}
    </update>
</mapper>
```

추가적으로 게시글 등록 시 게시글 번호가 Auto Increase로 부여되는데 Select문이 아닌 다른 SQL Query(insert, update 등) 를 실행하고서 결과를 봐야하는 상황이 생길때 사용하는 방법으로 useGeneratedKeys와 keyProperty 속성을 사용하는 방법이 있습니다.

게시물 등록 시 필요로 되는방법이기 때문에 articleMapper.xml 파일의 create와 관련된 sql문을 아래와 같이 수정하겠습니다. 

```java
<insert id="create" useGeneratedKeys="true" keyProperty="article_no">
        INSERT INTO tb_article (
            title
            , content
            , writer
            , file_cnt
        ) VALUES (
            #{title}
            , #{content}
            , #{writer}
            , #{fileCnt}
        )
    </insert>
```

#### **6-2. 게시글 Service 계층 수정**

게시글이 입력 처리가 되면 함께 게시글 첨부파일명이 게시글 첨부파일 테이블에 함께 입력되도록 ArticleServiceImpl클래스의 create()를 아래와 같이 수정해주겠습니다. 그리고 게시글 입력처리와 게시글 첨부파일 입력처리가 동시에 이루어지기 때문에 트랜잭션 처리를 반드시 해주어야 합니다.

```java
@Transactional
@Override
public void update(ArticleVO articleVO) throws Exception {
    	
        
        int article_no = articleVO.getArticle_no();
        articleFileDAO.deleteAllAttach(article_no);

        String[] files = articleVO.getFiles();
        if (files == null) {
        	articleVO.setFileCnt(0);
            articleDAO.update(articleVO);
            return;
        }

        articleVO.setFileCnt(files.length);
        articleDAO.update(articleVO);
        for (String fileName : files) {
        	articleFileDAO.replaceAttach(fileName, article_no);
        }
}
    
@Transactional
@Override
public void delete(Integer article_no) throws Exception {
    	articleFileDAO.deleteAllAttach(article_no);
        articleDAO.delete(article_no);
}
```

#### **6-3. UploadController 생성**

게시글 첨부파일 컨트롤러는 앞서 말한 것처럼 게시글 입력처리가 되기 전에 클라이언트로부터 AJAX통신을 통해 첨부파일을 미리 서버에 저장하는 역할을 수행하게 됩니다. 업로드 처리와 첨부파일 출력 매핑 메소드를 아래와 같이 작성해 줍니다. 

```java
@RestController
@RequestMapping("/file")
public class UploadController {

    private static final Logger logger = LoggerFactory.getLogger(UploadController.class);

    
    private final UploadService uploadService;
    
    @Inject
    public UploadController(UploadService uploadService) {
        this.uploadService = uploadService;
    }
    

    // 파일 저장 기본 경로 bean 등록
    @Resource(name = "uploadPath")
    private String uploadPath;

    // 업로드 파일
    @RequestMapping(value = "/upload", method = RequestMethod.POST, produces = "text/pliain;charset=UTF-8")
    public ResponseEntity<String> uploadFile(MultipartFile file) throws Exception {
        logger.info("========================================= FILE UPLOAD =========================================");
        logger.info("ORIGINAL FILE NAME : " + file.getOriginalFilename());
        logger.info("FILE SIZE : " + file.getSize());
        logger.info("CONTENT TYPE : " + file.getContentType());
        logger.info("===============================================================================================");
        return new ResponseEntity<String>(UploadFileUtils.uploadFile(uploadPath, file.getOriginalFilename(), file.getBytes()), HttpStatus.CREATED);
    }

    // 게시글 첨부파일 조회
    @RequestMapping(value = "/list/{article_no}")
    public ResponseEntity<List<String>> fileList(@PathVariable("article_no") Integer article_no) throws Exception {
    	
        ResponseEntity<List<String>> entity = null;
        try {
            entity = new ResponseEntity<List<String>>(uploadService.getAttach(article_no), HttpStatus.OK);
        } catch (Exception e) {
            e.printStackTrace();
            entity = new ResponseEntity<List<String>>(HttpStatus.BAD_REQUEST);
        }
        return entity;
    }

    // 업로드 파일 보여주기
    @RequestMapping(value = "/display")
    public ResponseEntity<byte[]> displayFile(String fileName) throws Exception {
        // InputStream : 바이트 단위로 데이터를 읽는다. 외부로부터 읽어 들이는 기능관련 클래스
        InputStream inputStream = null;
        ResponseEntity<byte[]> entity = null;
        logger.info("file name : " + fileName);
        try {
            // 파일 확장자 추출
            String formatName = fileName.substring(fileName.lastIndexOf(".") + 1);
            // 이미지 파일 여부 확인, 이미지 파일일 경우 이미지 MINEType 지정
            MediaType mediaType = MediaUtils.getMediaType(formatName);
            // HttpHeaders 객체 생성
            HttpHeaders httpHeaders = new HttpHeaders();
            // 실제 경로의 파일을 읽어들이고 InputStream 객체 생성
            inputStream = new FileInputStream(uploadPath + fileName);
            // 이미지 파일일 경우
            if (mediaType != null) {
                httpHeaders.setContentType(mediaType);
                // 이미지 파일이 아닐 경우
            } else {
                // 디렉토리 + UUID 제거
                fileName = fileName.substring(fileName.indexOf("_") + 1);
                // 다운로드 MIME Type 지정
                httpHeaders.setContentType(MediaType.APPLICATION_OCTET_STREAM);
                // 한글이름의 파일 인코딩처리
                httpHeaders.add("Content-Disposition", "attachment; filename=\"" +
                        new String(fileName.getBytes("UTF-8"), "ISO-8859-1") + "\"");
            }
            entity = new ResponseEntity<byte[]>(IOUtils.toByteArray(inputStream), httpHeaders, HttpStatus.CREATED);
        } catch (Exception e) {
            e.printStackTrace();
            entity = new ResponseEntity<byte[]>(HttpStatus.BAD_REQUEST);
        } finally {
            inputStream.close();
        }
        return entity;
    }

    // 단일 파일 데이터 삭제1 : 게시글 작성화면
    @ResponseBody
    @RequestMapping(value = "/delete", method = RequestMethod.POST)
    public ResponseEntity<String> boardWriteRemoveFile(String fileName) throws Exception {
        // 파일 삭제
        UploadFileUtils.removeFile(uploadPath, fileName);
        return new ResponseEntity<String>("DELETED", HttpStatus.OK);
    }

    // 단일 파일 데이터 삭제2 : 게시글 수정화면
    @Transactional
    @ResponseBody
    @RequestMapping(value = "/delete/{article_no}", method = RequestMethod.POST)
    public ResponseEntity<String> boardMofifyRemoveFile(@PathVariable("article_no") Integer article_no, String fileName, HttpServletRequest request) throws Exception {
        // DB에서 파일명 제거
        uploadService.deleteAttach(fileName);
        // 첨부파일 갯수 갱신
        uploadService.updateAttachCnt(article_no);
        // 파일 삭제
        UploadFileUtils.removeFile(uploadPath, fileName);
        return new ResponseEntity<String>("DELETED", HttpStatus.OK);
    }

    // 전체 파일 삭제 : 게시글 삭제 처리시
    @ResponseBody
    @RequestMapping(value = "/delete/all", method = RequestMethod.POST)
    public ResponseEntity<String> boardDeleteRemoveAllFiles(@RequestParam("files[]") String[] files) {
        // 파일이 없을 경우 메서드 종료
        if (files == null || files.length == 0) {
            return new ResponseEntity<String>("DELETED", HttpStatus.OK);
        }
        // 파일이 존재할 경우 반복문 수행
        for (String fileName : files) {
            // 파일 삭제
            UploadFileUtils.removeFile(uploadPath, fileName);
        }
        return new ResponseEntity<String>("DELETED", HttpStatus.OK);
    }

}
```

### **7. 게시글 작성 페이지 수정**

파일 업로드 영역의 CSS를 추가해줍니다. 

```
<style>
    .fileDrop {
        width: 100%;
        height: 200px;
        border: 2px dotted #0b58a2;
    }
</style>
```

그리고 페이지에서 작성자가 표시되는 곳의 하단에 첨부파일 영역을 추가해 주겠습니다. 

```java
<div class="form-group">
  <label for="writer">작성자</label> <input class="form-control"
  id="writer" name="writer" value="${login.userId}" readonly>
</div>
<%--첨부파일 영역 추가--%>
<div class="form-group">
  <div class="fileDrop">
    <br/>
    <br/>
    <br/>
    <br/>
    <p class="text-center"><i class="fa fa-paperclip"></i> 첨부파일을 드래그해주세요.</p>
  </div>
</div>
<%--첨부파일 영역 추가--%>
<div class="card-footer">
	<ul class="mailbox-attachments clearfix uploadedList"></ul>
</div>
```

이어서 첨부파일 출력을 위한 Handlebars 템플릿을 작성해 주겠습니다. 

```java
<%--첨부파일 하나의 영역--%>
<%--이미지--%>
<script id="templatePhotoAttach" type="text/x-handlebars-template">
    <li>
        <span class="mailbox-attachment-icon has-img"><img src="{{imgsrc}}" alt="Attachment"></span>
        <div class="mailbox-attachment-info">
            <a href="{{getLink}}" class="mailbox-attachment-name" data-lightbox="uploadImages"><i class="fas fa-camera"></i> {{fileName}}</a>
            <a href="{{fullName}}" class="btn btn-default btn-xs float-right delBtn"><i class="far fa-trash-alt"></i></a>
        </div>
    </li>
</script>
<%--일반 파일--%>
<script id="templateFileAttach" type="text/x-handlebars-template">
    <li>
        <span class="mailbox-attachment-icon has-img"><img src="{{imgsrc}}" alt="Attachment"></span>
        <div class="mailbox-attachment-info">
            <a href="{{getLink}}" class="mailbox-attachment-name"><i class="fas fa-paperclip"></i> {{fileName}}</a>
            <a href="{{fullName}}" class="btn btn-default btn-xs float-right delBtn"><i class="far fa-trash-alt"></i></a>
        </div>
    </li>
</script>
```

#### **7-1. 첨부파일 업로드/출력/삭제를 위한 JS파일 작성**

 첨부파일 업로드/출력/삭제처리를 위한 JS코드는 /resources/dist/js에 upload.js파일을 생성해서 따로 작성해주고, 아래와 같이 게시글 작성페이지에 포함시켜주겠습니다. 첨부파일 기능을 처리하는 JS코드의 내용이 많고, 게시글 입력/조회/수정 페이지에 공통으로 들어가는 코드의 중복을 방지하기 위해서입니다.

```java
<script type="text/javascript" src="${path}/resources/dist/js/upload.js"></script>
// 업로드 JS

// 파일 정보 가공
function getFileInfo(fullName) {

    var fileName;   // 화면에 출력할 파일명
    var imgsrc;     // 썸네일 or 파일아이콘 이미지 파일 요청 URL
    var getLink;    // 원본파일 요청 URL

    var fileLink;   // 날짜경로를 제외한 나머지 파일명 (UUID_파일명.확장자)
    // 이미지 파일일 경우
    if (checkImageType(fullName)) {
        // 썸네일 파일 이미지 URL
        imgsrc = "/mypage/file/display?fileName=" + fullName;
        // UUID_파일명.확장자 (s_ 제외 : 원본이미지)
        fileLink = fullName.substr(14);
        // 원본파일 요청 URL
        var front = fullName.substr(0, 12); // 날짜 경로
        var end = fullName.substr(14);      // 파일명(s_ 제외)
        getLink = "/mypage/file/display?fileName=" + front + end;
    
    // 이미지 파일이 아닐 경우
    } else {
        // 파일 아이콘 이미지 URL
    	imgsrc = "/mypage/resources/upload/files/file-icon.png";
        // UUID_파일명.확장자
        fileLink = fullName.substr(12);
        // 파일 요청 url
        getLink = "/mypage/file/display?fileName=" + fullName;
    }
    // 화면에 출력할 파일명
    fileName = fileLink.substr(fileLink.indexOf("_") + 1);

    return {fileName: fileName, imgsrc: imgsrc, getLink: getLink, fullName: fullName};
}

// 이미지 파일 유무 확인
function checkImageType(fileName) {
    // 정규 표현식을 통해 이미지 파일 유무 확인
    var pattern = /jpg$|gif$|png$|jpge$/i;
    return fileName.match(pattern);
}
```

#### **7-2. 원본 이미지 파일 출력을 위한 ligthbox 라이브러리 적용**

첨부파일이 이미지 타입인 경우 화면에 출력할 때 썸네일을 출력하고, 해당 썸네일을 클릭하면 원본 이미지 파일을 출력해주기 위해서 head.jsp와 plugin_js.jsp에 lightbox플러그인 css와 js파일을 아래와 같이 추가해줍니다.

```java
<link rel="stylesheet" href="${path}/plugins/ekko-lightbox/ekko-lightbox.css">
<script src="${path}/plugins/ekko-lightbox/ekko-lightbox.js"></script>
```

#### **7-3. 게시글 입력 페이지(write.jsp)의 첨부파일 이벤트 처리 JS 코드 작성**

```java
<script>
    /*====================================================게시판 첨부파일 업로드 관련======================================*/
    $(document).ready(function () {
        var fileDropDiv = $(".fileDrop");
        var templatePhotoAttach = Handlebars.compile($("#templatePhotoAttach").html());
        var templateFileAttach = Handlebars.compile($("#templateFileAttach").html());
        // 전체 페이지 파일 끌어 놓기 기본 이벤트 방지 : 지정된 영역외에 파일 드래그 드랍시 페이지 이동방지
        $(".content-wrapper").on("dragenter dragover drop", function (event) {
            event.preventDefault();
        });
        // 파일 끌어 놓기 기본 이벤트 방지
        fileDropDiv.on("dragenter dragover", function (event) {
            event.preventDefault();
        });
        // 파일 드랍 이벤트 : 파일 전송 처리, 파일 화면 출력
        fileDropDiv.on("drop", function (event) {
            event.preventDefault();
            var files = event.originalEvent.dataTransfer.files;
            var file = files[0];
            var formData = new FormData();
            formData.append("file", file);
            $.ajax({
                url: "/mypage/file/upload",
                data: formData,
                dataType: "text",
                processData: false,
                contentType: false,
                type: "POST",
                success: function (data) {
                    // 파일정보 가공
                    var fileInfo = getFileInfo(data);
                    // 이미지 파일일 경우
                    if (data.substr(12, 2) == "s_") {
                    	console.log("This is Image");
                        var html = templatePhotoAttach(fileInfo);
                    // 이미지 파일이 아닐 경우
                    } else {
                        html = templateFileAttach(fileInfo);
                    }
                    $(".uploadedList").append(html);
                }
            });
        });
        // 글 저장 버튼 클릭 이벤트 : 파일명 DB 저장 처리
        $("#writeForm").submit(function (event) {
            event.preventDefault();
            var that = $(this);
            var str = "";
            $(".uploadedList .delBtn").each(function (index) {
                str += "<input type='hidden' name='files["+index+"]' value='"+$(this).attr("href")+"'>"
            });
            that.append(str);
            that.get(0).submit();
        });
        // 파일 삭제 버튼 클릭 이벤트 : 파일삭제, 파일명 DB 삭제 처리
        $(document).on("click", ".delBtn", function (event) {
            event.preventDefault();
            var that = $(this);
            $.ajax({
                url: "/mypage/file/delete",
                type: "post",
                data: {fileName:$(this).attr("href")},
                dataType: "text",
                success: function (result) {
                    if (result == "DELETED") {
                        alert("삭제되었습니다.");
                        that.parents("li").remove();
                    }
                }
            });
        });
    });
</script>
```

### **8. 게시글 수정 페이지 수정**

```java
<div class="card-body">
  <input type="hidden" name="article_no" value="${article.article_no}">
  <input type="hidden" name="page" value="${searchCriteria.page}">
  <input type="hidden" name="perPageNum" value="${searchCriteria.perPageNum}">
  <input type="hidden" name="searchType" value="${searchCriteria.searchType}">
  <input type="hidden" name="keyword" value="${searchCriteria.keyword}">
  <div class="form-group">
    <label for="title">제목</label> <input class="form-control"
    id="title" name="title" placeholder="제목을 입력해주세요"
    value="${article.title}">
  </div>
  <div class="form-group">
    <label for="content">내용</label>
    <textarea class="form-control" id="content" name="content"
    rows="30" placeholder="내용을 입력해주세요" style="resize: none;">${article.content}</textarea>
  </div>
  <div class="form-group">
    <label for="writer">작성자</label> <input class="form-control"
    id="writer" name="writer" value="${article.writer}" readonly>
  </div>
  <div class="form-group">
    <div class="fileDrop">
      <br /> <br /> <br /> <br />
      <p class="text-center">
        <i class="fas fa-paperclip"></i> 첨부파일을 드래그해주세요.
      </p>
    </div>
  </div>
</div>
<div class="box-footer">
  <ul class="mailbox-attachments clearfix uploadedList"></ul>
</div>
```

그리고 수정 페이지 역시 Script 부분을 아래와 같이 작성해 줍니다. 

```java
<script>
$(document).ready(function () {
	var article_no = ${article.article_no}; // 현재 게시글 번호
    var templatePhotoAttach = Handlebars.compile($("#templatePhotoAttach").html()); // 이미지 Template
    var templateFileAttach = Handlebars.compile($("#templateFileAttach").html());   // 일반파일 Template
    /*================================================게시판 업로드 첨부파일 추가관련===================================*/
    // 전체 페이지 파일 끌어 놓기 기본 이벤트 방지 : 지정된 영역외에 파일 드래그 드랍시 페이지 이동방지
    $(".content-wrapper").on("dragenter dragover drop", function (event) {
        event.preventDefault();
    });
    // 파일 끌어 놓기 기본 이벤트 방지
    $(".fileDrop").on("dragenter dragover", function (event) {
        event.preventDefault();
    });
    // 파일 드랍 이벤트 : 파일 전송 처리
    $(".fileDrop").on("drop", function (event) {
        event.preventDefault();
        var files = event.originalEvent.dataTransfer.files;
        var file = files[0];
        var formData = new FormData();
        formData.append("file", file);
        $.ajax({
            url: "/mypage/file/upload",
            data: formData,
            dataType: "text",
            processData: false,
            contentType: false,
            type: "POST",
            success: function (data) {
                // 파일정보 가공
                var fileInfo = getFileInfo(data);
                // 이미지 파일일 경우
                if (fileInfo.fullName.substr(12, 2) == "s_") {
                    var html = templatePhotoAttach(fileInfo);
                    // 이미지 파일이 아닐경우
                } else {
                    html = templateFileAttach(fileInfo);
                }
                // 목록에 출력
                $(".uploadedList").append(html);
            }
        });
    });
    // 수정 처리시 파일 정보도 함께 처리
    $("#writeForm").submit(function (event) {
        event.preventDefault();
        var that = $(this);
        var str = "";
        $(".uploadedList .delBtn").each(function (index) {
            str += "<input type='hidden' name='files["+index+"]' value='"+$(this).attr("href")+"'>"
        });
        that.append(str);
        that.get(0).submit();
    });
    // 파일 삭제 버튼 클릭 이벤트
    $(document).on("click", ".delBtn", function (event) {
        event.preventDefault();
        if (confirm("삭제하시겠습니까? 삭제된 파일은 복구할 수 없습니다.")) {
            var that = $(this);
            $.ajax({
                url: "/mypage/file/delete/" + article_no,
                type: "post",
                data: {fileName:$(this).attr("href")},
                dataType: "text",
                success: function (result) {
                    if (result == "DELETED") {
                        alert("삭제되었습니다.");
                        that.parents("li").remove();
                    }
                }
            });
        }
    });
    /*================================================게시판 업로드 첨부파일 목록관련===================================*/
    $.getJSON("/mypage/file/list/" + article_no, function (list) {
        $(list).each(function () {
            var fileInfo = getFileInfo(this);
            // 이미지 파일일 경우
            if (fileInfo.fullName.substr(12, 2) == "s_") {
                var html = templatePhotoAttach(fileInfo);
                // 이미지 파일이 아닐 경우
            } else {
                html = templateFileAttach(fileInfo);
            }
            $(".uploadedList").append(html);
        })
    });
    
    var formObj = $("form[role='form']");
    console.log(formObj);

    $(".modBtn").on("click", function () {
        formObj.submit();
    });

    $(".cancelBtn").on("click", function () {
        history.go(-1);
    });

    $(".listBtn").on("click", function () {
        self.location = "${path}/article/paging/search/list?page=${searchCriteria.page}"
            + "&perPageNum=${searchCriteria.perPageNum}"
            + "&searchType=${searchCriteria.searchType}"
            + "&keyword=${searchCriteria.keyword}";
    });

});
</script>
```


package Jjami_BE.auth.security;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configuration.WebSecurityCustomizer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;

@Configuration
@EnableWebSecurity
public class SecurityConfig {

    @Bean
    public SecurityFilterChain securityFilterChain(HttpSecurity http) throws Exception {
        http
                .csrf(AbstractHttpConfigurer::disable)
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers("/", "/login", "/register").permitAll() // 🔹 로그인 및 회원가입 허용
                        .anyRequest().authenticated() // 🔹 그 외 요청은 인증 필요
                )
                .formLogin(AbstractHttpConfigurer::disable) // 🔹 기본 로그인 페이지 비활성화
                .httpBasic(AbstractHttpConfigurer::disable) // 🔹 HTTP Basic 인증 비활성화
                .logout(logout -> logout.logoutSuccessUrl("/")) // 🔹 로그아웃 후 메인 페이지로 리다이렉트
                .sessionManagement(session -> session.sessionCreationPolicy(SessionCreationPolicy.STATELESS));

        return http.build();
    }

    // 🔥 특정 경로는 Security 필터에서 완전히 제외
    @Bean
    public WebSecurityCustomizer webSecurityCustomizer() {
        return web -> web.ignoring().requestMatchers(
                "/index.html", "/static/**", "/css/**", "/js/**", "/images/**", "/favicon.ico", // 🔹 index.html과 정적 리소스
                "/swagger-ui/**", "/v3/api-docs/**",  // 🔹 Swagger API 문서
                "/public/**", "/health", "/actuator/**"  // 🔹 공용 API 및 헬스 체크
        );
    }
}


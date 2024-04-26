

public struct RefreshTokenResponse: Codable {
    public var accessToken: String
    public var refreshToken: String
    
    public init(accessToken: String, refreshToken: String) {
      self.accessToken = accessToken
      self.refreshToken = refreshToken
    }
}
